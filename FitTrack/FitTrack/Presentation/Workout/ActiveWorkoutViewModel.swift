//
//  ActiveWorkoutViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import Combine
import Foundation

class ActiveWorkoutViewModel: ObservableObject {
    
    private let workoutService: WorkoutSessionProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var elapsedTime: String = "00:00"
    @Published var currentWorkout: WorkoutTemplate = .empty
    @Published var isMinimised: Bool = false
    
    let restTimer = RestTimerManager()
    
    var onMinimize: (() -> Void)?
    var onFinish: (() -> Void)?
    
    init(workoutService: WorkoutSessionProtocol) {
        self.workoutService = workoutService
        setupSubscriptions()
        
        restTimer.resumeIfNeeded()
    }
    
    private func setupSubscriptions() {
        workoutService.timerPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] time in
                guard let self = self else { return }
                
                let formatted = self.formatTime(time)
                self.elapsedTime = formatted
                
                if #available(iOS 16.1, *) {
                    LiveActivityManager.shared.updateWorkoutActivity(elapsedTime: formatted)
                }
            }
            .store(in: &cancellables)
        
        workoutService.currentWorkoutPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] workout in
                self?.currentWorkout = workout ?? .empty
            }
            .store(in: &cancellables)
        
        $currentWorkout
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] workout in
                self?.workoutService.updateWorkout(workout)
            }
            .store(in: &cancellables)
        
        restTimer.$isActive
            .sink { [weak self] isActive in
                if #available(iOS 16.1, *) {
                    LiveActivityManager.shared.updateWorkoutActivity(isResting: isActive)
                }
            }
            .store(in: &cancellables)
        
        restTimer.$remainingSeconds
            .sink { [weak self] remaining in
                if #available(iOS 16.1, *) {
                    LiveActivityManager.shared.updateWorkoutActivity(restTimeRemaining: remaining)
                }
            }
            .store(in: &cancellables)
    }
    
    func startWorkout(from template: WorkoutTemplate) {
        restTimer.skip()
        
        workoutService.startWorkout(template: template)
        
        BackgroundAudioManager.shared.startBackgroundAudio()
        
        Task {
            let healthKitService = HealthKitService()
            if healthKitService.isHealthDataAvailable() {
                try? await healthKitService.requestAuthorization()
            }
            
            if #available(iOS 16.1, *) {
                let firstExercise = template.exercises.first
                let firstSet = firstExercise?.sets.first
                
                let exerciseName = firstExercise?.exerciseName ?? "No Exercise"
                let exerciseImageUrl = firstExercise?.imageUrl
                let totalSets = firstExercise?.sets.count ?? 0
                let targetWeight = formatWeight(firstSet?.targetWeightKg) 
                let targetReps = formatReps(firstSet?.targetReps)
                
                await LiveActivityManager.shared.startWorkoutActivity(
                    workoutId: template.id,
                    workoutName: template.name,
                    exerciseName: exerciseName,
                    exerciseImageUrl: exerciseImageUrl,
                    currentSet: 1,
                    totalSets: totalSets,
                    targetWeight: targetWeight,
                    targetReps: targetReps
                )
            }
            
            await preloadExerciseImages(for: template)
        }
    }

    private func preloadExerciseImages(for template: WorkoutTemplate) async {
        for exercise in template.exercises {
            if let imageUrl = exercise.imageUrl {
                if ImageManager.shared.getLocalImagePath(for: imageUrl) == nil {
                    _ = await ImageManager.shared.downloadAndSaveImageAsync(from: imageUrl)
                }
            }
        }
    }
    
    func finishWorkout() {
        restTimer.skip()
        
        workoutService.finishWorkout()
        
        BackgroundAudioManager.shared.stopBackgroundAudio()
        
        if #available(iOS 16.1, *) {
            LiveActivityManager.shared.endWorkoutActivity()
        }
        
        onFinish?()
    }
    
    func minimizeWorkout() {
        workoutService.minimizeWorkout()
        restTimer.pause()
        onMinimize?()
    }
    
    func resumeTimerIfNeeded() {
        workoutService.resumeWorkout()
        restTimer.resumeIfNeeded()
        
        if #available(iOS 16.1, *) {
            Task {
                await syncLiveActivityWithCurrentState()
            }
        }
    }
    
    @available(iOS 16.1, *)
        private func syncLiveActivityWithCurrentState() async {
            for exercise in currentWorkout.exercises {
                for set in exercise.sets {
                    if set.isCompleted != true {
                        await LiveActivityManager.shared.updateWorkoutActivityAsync(
                            elapsedTime: elapsedTime,
                            exerciseName: exercise.exerciseName,
                            exerciseImageUrl: exercise.imageUrl,
                            currentSet: set.setNumber,
                            totalSets: exercise.sets.count,
                            targetWeight: formatWeight(set.targetWeightKg),
                            targetReps: formatReps(set.targetReps),
                            isResting: restTimer.isActive,
                            restTimeRemaining: restTimer.remainingSeconds,
                            isFinished: false
                        )
                        return
                    }
                }
            }
            
            await LiveActivityManager.shared.updateWorkoutActivityAsync(isFinished: true)
        }
    
    func completeCurrentSet() {
        
        for exerciseIndex in currentWorkout.exercises.indices {
            for setIndex in currentWorkout.exercises[exerciseIndex].sets.indices {
                let set = currentWorkout.exercises[exerciseIndex].sets[setIndex]
                
                if set.isCompleted != true {
                    
                    currentWorkout.exercises[exerciseIndex].sets[setIndex].isCompleted = true
                    workoutService.updateWorkout(currentWorkout)
                    
                    if set.restSeconds > 0 {
                        startRestTimer(seconds: set.restSeconds)
                    }
                    
                    updateLiveActivityToNextSet()
                    return
                }
            }
        }
        
    }
    
    private func updateLiveActivityToNextSet() {
        guard #available(iOS 16.1, *) else { return }
        
        for exercise in currentWorkout.exercises {
            for set in exercise.sets {
                if set.isCompleted != true {
                    
                    Task {
                        await LiveActivityManager.shared.updateWorkoutActivityAsync(
                            exerciseName: exercise.exerciseName,
                            exerciseImageUrl: exercise.imageUrl,
                            currentSet: set.setNumber,
                            totalSets: exercise.sets.count,
                            targetWeight: formatWeight(set.targetWeightKg),
                            targetReps: formatReps(set.targetReps),
                            isResting: false,
                            isFinished: false
                        )
                    }
                    return
                }
            }
        }
        
        Task {
            await LiveActivityManager.shared.updateWorkoutActivityAsync(isFinished: true)
        }
    }
        
    func startRestTimer(seconds: Int) {
        restTimer.startRestTimer(seconds: seconds)
    }
        
    func addExercises(_ newExercises: [Exercise]) {
        for exercise in newExercises {
            let defaultSet = ExerciseSet(
                setNumber: 1,
                targetWeightKg: nil,
                targetReps: nil,
                restSeconds: 60,
                isCompleted: false
            )
            
            let newTemplateExercise = TemplateExercise(
                id: UUID().uuidString,
                exerciseId: exercise.id,
                exerciseName: exercise.name,
                imageUrl: exercise.thumbnailURL,
                muscleGroup: exercise.muscleGroup,
                equipment: exercise.equipment,
                sets: [defaultSet]
            )
            
            currentWorkout.exercises.append(newTemplateExercise)
        }
        workoutService.updateWorkout(currentWorkout)
        
        if #available(iOS 16.1, *) {
            Task {
                await updateLiveActivityToNextSetAsync()
            }
        }
    }

    func addSet(to exerciseId: String) {
        guard let exerciseIndex = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        let nextNumber = currentWorkout.exercises[exerciseIndex].sets.count + 1
        let previousSet = currentWorkout.exercises[exerciseIndex].sets.last
        
        let newSet = ExerciseSet(
            setNumber: nextNumber,
            targetWeightKg: previousSet?.targetWeightKg,
            targetReps: previousSet?.targetReps,
            restSeconds: previousSet?.restSeconds ?? 60,
            isCompleted: false
        )
        
        currentWorkout.exercises[exerciseIndex].sets.append(newSet)
        workoutService.updateWorkout(currentWorkout)
        
        if #available(iOS 16.1, *) {
            Task {
                await updateLiveActivityToNextSetAsync()
            }
        }
    }

    private func updateLiveActivityToNextSetAsync() async {
        guard #available(iOS 16.1, *) else { return }
        
        for exercise in currentWorkout.exercises {
            for set in exercise.sets {
                if set.isCompleted != true {
                    
                    await LiveActivityManager.shared.updateWorkoutActivityAsync(
                        exerciseName: exercise.exerciseName,
                        exerciseImageUrl: exercise.imageUrl,
                        currentSet: set.setNumber,
                        totalSets: exercise.sets.count,
                        targetWeight: formatWeight(set.targetWeightKg),
                        targetReps: formatReps(set.targetReps),
                        isResting: false,
                        isFinished: false
                    )
                    return
                }
            }
        }
        
        await LiveActivityManager.shared.updateWorkoutActivityAsync(isFinished: true)
    }
    
    func deleteExercise(_ exerciseToDelete: TemplateExercise) {
        if let index = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseToDelete.id }) {
            currentWorkout.exercises.remove(at: index)
        }
        workoutService.updateWorkout(currentWorkout)
    }
    
    func updateRestTime(for exerciseId: String, to newRestTime: Int) {
        guard let exerciseIndex = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        for index in currentWorkout.exercises[exerciseIndex].sets.indices {
            currentWorkout.exercises[exerciseIndex].sets[index].restSeconds = newRestTime
        }
        workoutService.updateWorkout(currentWorkout)
    }
    
    func getDefaultRestTime(for exerciseId: String) -> Int {
        guard let exerciseIndex = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseId }),
              let firstSet = currentWorkout.exercises[exerciseIndex].sets.first else {
            return 60
        }
        return firstSet.restSeconds
    }
        
    private func formatWeight(_ weight: Double?) -> String {
        guard let weight = weight else { return "-" }
        return String(format: "%.1f kg", weight)
    }
    
    private func formatReps(_ reps: Int?) -> String {
        guard let reps = reps else { return "-" }
        return "\(reps) reps"
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "00:00"
    }
}

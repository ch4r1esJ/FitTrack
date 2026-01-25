//
//  ActiveWorkoutViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import Combine
import Foundation

class ActiveWorkoutViewModel: ObservableObject {
    
    @Published var currentWorkout: WorkoutTemplate = .empty
    @Published var isMinimised: Bool = false
    @Published var elapsedTime: String = "00:00"
        
    private let workoutStateRepository: WorkoutStateRepositoryProtocol
    private let workoutHistoryRepository: WorkoutHistoryRepositoryProtocol
    private let healthKitRepository: HealthKitRepositoryProtocol
    private let backgroundAudioService: BackgroundAudioService
    private let notificationService: NotificationService
        
    private let workoutTimer: WorkoutTimerManager
    private let liveActivityHelper: LiveActivityHelper?
    let restTimer: RestTimerManager
    
    private var cancellables = Set<AnyCancellable>()
        
    var onMinimize: (() -> Void)?
    var onFinish: (() -> Void)?
    
    init(
        workoutStateRepository: WorkoutStateRepositoryProtocol,
        workoutHistoryRepository: WorkoutHistoryRepositoryProtocol,
        healthKitRepository: HealthKitRepositoryProtocol,
        backgroundAudioService: BackgroundAudioService,
        liveActivityService: LiveActivityService?,
        notificationService: NotificationService,
        restTimer: RestTimerManager
    ) {
        self.workoutStateRepository = workoutStateRepository
        self.workoutHistoryRepository = workoutHistoryRepository
        self.healthKitRepository = healthKitRepository
        self.backgroundAudioService = backgroundAudioService
        self.notificationService = notificationService
        self.restTimer = restTimer
        
        self.workoutTimer = WorkoutTimerManager()
        
        if #available(iOS 16.1, *), let service = liveActivityService {
            self.liveActivityHelper = LiveActivityHelper(liveActivityService: service)
        } else {
            self.liveActivityHelper = nil
        }
        
        setupSubscriptions()
        loadPersistedWorkoutIfNeeded()
        restTimer.resumeIfNeeded()
    }
        
    private func setupSubscriptions() {
        workoutTimer.$elapsedSeconds
            .sink { [weak self] _ in
                self?.saveWorkoutState()
            }
            .store(in: &cancellables)
        
        workoutTimer.$formattedTime
            .sink { [weak self] time in
                self?.elapsedTime = time
                
                if #available(iOS 16.1, *) {
                    Task {
                        await self?.liveActivityHelper?.updateElapsedTime(time)
                    }
                }
            }
            .store(in: &cancellables)
        
        restTimer.$isActive
            .combineLatest(restTimer.$remainingSeconds)
            .sink { [weak self] isActive, remaining in
                if #available(iOS 16.1, *) {
                    Task {
                        await self?.liveActivityHelper?.updateRestingState(
                            isResting: isActive,
                            remainingSeconds: remaining
                        )
                    }
                }
            }
            .store(in: &cancellables)
        
        $currentWorkout
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveWorkoutState()
            }
            .store(in: &cancellables)
    }
    
    func startWorkout(from template: WorkoutTemplate) {
        restTimer.skip()
        
        currentWorkout = template
        workoutTimer.startTimer()
        saveWorkoutState()
        
        backgroundAudioService.startBackgroundAudio()
        
        Task {
            if healthKitRepository.isHealthDataAvailable() {
                try? await healthKitRepository.requestAuthorization()
            }
            notificationService.requestPermission()
            
            if #available(iOS 16.1, *) {
                await liveActivityHelper?.startActivity(for: template)
            }
            
            await preloadExerciseImages(for: template)
        }
    }
    
    func finishWorkout() {
        restTimer.skip()
        
        let workoutToSave = currentWorkout
        let workoutStartDate = workoutTimer.startDate
        let workoutDuration = workoutTimer.elapsedSeconds
        
        currentWorkout = .empty
        workoutTimer.reset()
        try? workoutStateRepository.clearWorkoutState()
        
        backgroundAudioService.stopBackgroundAudio()
        if #available(iOS 16.1, *) {
            liveActivityHelper?.endActivity()
        }
        
        Task {
            await saveCompletedWorkout(
                template: workoutToSave,
                startDate: workoutStartDate,
                duration: workoutDuration
            )
        }
        
        onFinish?()
    }
    
    func discardWorkout() {
        restTimer.skip()
        
        currentWorkout = .empty
        workoutTimer.reset()
        try? workoutStateRepository.clearWorkoutState()
        
        backgroundAudioService.stopBackgroundAudio()
        if #available(iOS 16.1, *) {
            liveActivityHelper?.endActivity()
        }
    }
    
    func minimizeWorkout() {
        workoutTimer.stopTimer()
        saveWorkoutState()
        restTimer.pause()
        onMinimize?()
    }
    
    func resumeTimerIfNeeded() {
        if let startDate = workoutTimer.startDate {
            workoutTimer.resumeTimer(
                withElapsedTime: workoutTimer.elapsedSeconds,
                startDate: startDate
            )
        }
        
        restTimer.resumeIfNeeded()
        
        if #available(iOS 16.1, *) {
            Task {
                await liveActivityHelper?.syncWithCurrentWorkout(
                    currentWorkout,
                    elapsedTime: workoutTimer.formattedTime,
                    isResting: restTimer.isActive,
                    restRemaining: restTimer.remainingSeconds
                )
            }
        }
    }
        
    func completeCurrentSet() {
        for exerciseIndex in currentWorkout.exercises.indices {
            for setIndex in currentWorkout.exercises[exerciseIndex].sets.indices {
                let set = currentWorkout.exercises[exerciseIndex].sets[setIndex]
                
                if set.isCompleted != true {
                    currentWorkout.exercises[exerciseIndex].sets[setIndex].isCompleted = true
                    
                    if set.restSeconds > 0 {
                        startRestTimer(seconds: set.restSeconds)
                    }
                    
                    if #available(iOS 16.1, *) {
                        Task {
                            await liveActivityHelper?.updateToNextSet(in: currentWorkout)
                        }
                    }
                    
                    return
                }
            }
        }
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
        
        if #available(iOS 16.1, *) {
            Task {
                await liveActivityHelper?.updateToNextSet(in: currentWorkout)
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
        
        if #available(iOS 16.1, *) {
            Task {
                await liveActivityHelper?.updateToNextSet(in: currentWorkout)
            }
        }
    }
    
    func deleteExercise(_ exerciseToDelete: TemplateExercise) {
        if let index = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseToDelete.id }) {
            currentWorkout.exercises.remove(at: index)
        }
    }
    
    func updateRestTime(for exerciseId: String, to newRestTime: Int) {
        guard let exerciseIndex = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        for index in currentWorkout.exercises[exerciseIndex].sets.indices {
            currentWorkout.exercises[exerciseIndex].sets[index].restSeconds = newRestTime
        }
    }
    
    func getDefaultRestTime(for exerciseId: String) -> Int {
        guard let exerciseIndex = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseId }),
              let firstSet = currentWorkout.exercises[exerciseIndex].sets.first else {
            return 60
        }
        return firstSet.restSeconds
    }
    
    func startRestTimer(seconds: Int) {
        restTimer.startRestTimer(seconds: seconds)
    }
        
    private func saveWorkoutState() {
        guard let startDate = workoutTimer.startDate else { return }
        
        let state = ActiveWorkoutState(
            workout: currentWorkout,
            startDate: startDate,
            elapsedTime: workoutTimer.elapsedSeconds
        )
        
        try? workoutStateRepository.saveWorkoutState(state)
    }
    
    private func loadPersistedWorkoutIfNeeded() {
        guard let persisted = try? workoutStateRepository.loadWorkoutState() else {
            return
        }
        
        currentWorkout = persisted.workout
        workoutTimer.resumeTimer(
            withElapsedTime: persisted.elapsedTime,
            startDate: persisted.startDate
        )
    }
        
    private func saveCompletedWorkout(
        template: WorkoutTemplate,
        startDate: Date?,
        duration: TimeInterval
    ) async {
        guard let start = startDate else { return }
        
        let endDate = Date()
        
        let completedExercises = template.exercises.map { exercise -> CompletedExercise in
            let completedSets = exercise.sets.map { set -> CompletedSet in
                CompletedSet(
                    id: set.id,
                    setNumber: set.setNumber,
                    targetWeightKg: set.targetWeightKg,
                    targetReps: set.targetReps,
                    actualWeightKg: set.isCompleted == true ? set.targetWeightKg : nil,
                    actualReps: set.isCompleted == true ? set.targetReps : nil,
                    isCompleted: set.isCompleted ?? false
                )
            }
            
            return CompletedExercise(
                id: exercise.id,
                exerciseId: exercise.exerciseId,
                exerciseName: exercise.exerciseName,
                muscleGroup: exercise.muscleGroup,
                equipment: exercise.equipment,
                sets: completedSets
            )
        }
        
        let totalVolume = completedExercises.reduce(0.0) { $0 + $1.totalVolume }
        let totalSets = template.exercises.reduce(0) { $0 + $1.sets.count }
        let completedSets = template.exercises.reduce(0) { total, exercise in
            total + exercise.sets.filter { $0.isCompleted == true }.count
        }
        
        let completedWorkout = CompletedWorkout(
            id: UUID().uuidString,
            templateId: template.id,
            templateName: template.name,
            userId: template.userId,
            startDate: start,
            endDate: endDate,
            duration: duration,
            exercises: completedExercises,
            totalVolume: totalVolume,
            totalSets: totalSets,
            completedSets: completedSets
        )
        
        try? await workoutHistoryRepository.saveCompletedWorkout(completedWorkout)
        
        if healthKitRepository.isHealthDataAvailable() {
            try? await healthKitRepository.saveWorkout(completedWorkout)
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
}

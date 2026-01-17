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
                self?.elapsedTime = self?.formatTime(time) ?? "00:00"
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
    }
    
    func startWorkout(from template: WorkoutTemplate) {
        workoutService.startWorkout(template: template)
    }
    
    func finishWorkout() {
        workoutService.finishWorkout()
        onFinish?()
    }
    
    func minimizeWorkout() {
        workoutService.minimizeWorkout()
        onMinimize?()
    }
    
    func resumeTimerIfNeeded() {
        workoutService.resumeWorkout()
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
    }
    
    func deleteExercise(_ exerciseToDelete: TemplateExercise) {
        if let index = currentWorkout.exercises.firstIndex(where: { $0.id == exerciseToDelete.id }) {
            currentWorkout.exercises.remove(at: index)
        }
        workoutService.updateWorkout(currentWorkout)
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
        
    private func formatTime(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "00:00"
    }
}

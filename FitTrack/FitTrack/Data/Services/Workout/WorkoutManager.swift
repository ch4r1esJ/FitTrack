//
//  WorkoutManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import Combine
import Foundation

class WorkoutManager: WorkoutSessionProtocol {
    
    static let shared = WorkoutManager()
    
    private var stateSubject: CurrentValueSubject<WorkoutState, Never>
    private var currentWorkoutSubject: CurrentValueSubject<WorkoutTemplate?, Never>
    private var elapsedTimeSubject: CurrentValueSubject<TimeInterval, Never>
    
    private var timer: Timer?
    private var startDate: Date?
    
    private let workoutHistoryService: WorkoutHistoryServiceProtocol
    private let healthKitService: HealthKitServiceProtocol
    
    var statePublisher: AnyPublisher<WorkoutState, Never> { stateSubject.eraseToAnyPublisher() }
    var currentWorkoutPublisher: AnyPublisher<WorkoutTemplate?, Never> { currentWorkoutSubject.eraseToAnyPublisher() }
    var timerPublisher: AnyPublisher<TimeInterval, Never> { elapsedTimeSubject.eraseToAnyPublisher() }
    
    init(
        workoutHistoryService: WorkoutHistoryServiceProtocol = FirebaseWorkoutHistoryService(),
        healthKitService: HealthKitServiceProtocol = HealthKitService()
    ) {
        self.workoutHistoryService = workoutHistoryService
        self.healthKitService = healthKitService
        
        self.stateSubject = CurrentValueSubject(.inactive)
        self.currentWorkoutSubject = CurrentValueSubject(nil)
        self.elapsedTimeSubject = CurrentValueSubject(0)
        
        loadPersistedWorkout()
    }
        
    func startWorkout(template: WorkoutTemplate) {
        currentWorkoutSubject.send(template)
        elapsedTimeSubject.send(0)
        stateSubject.send(.active)
        startDate = Date()
        startTimer()
        persistWorkout()
    }
    
    func pauseWorkout() {
        stateSubject.send(.paused)
        timer?.invalidate()
        timer = nil
        persistWorkout()
    }
    
    func resumeWorkout() {
        stateSubject.send(.active)
        startTimer()
        persistWorkout()
    }
    
    func minimizeWorkout() {
        stateSubject.send(.minimized)
        persistWorkout()
    }
    
    func finishWorkout() {
        timer?.invalidate()
        timer = nil
        
        let workoutToSave = currentWorkoutSubject.value
        let workoutStartDate = startDate
        let workoutDuration = elapsedTimeSubject.value
        
        stateSubject.send(.inactive)
        currentWorkoutSubject.send(nil)
        elapsedTimeSubject.send(0)
        startDate = nil
        
        WorkoutPersistence.clearWorkout()
        
        Task {
            await saveCompletedWorkout(
                template: workoutToSave,
                startDate: workoutStartDate,
                duration: workoutDuration
            )
        }
    }
    
    func discardWorkout() {
        timer?.invalidate()
        timer = nil
        
        stateSubject.send(.inactive)
        currentWorkoutSubject.send(nil)
        elapsedTimeSubject.send(0)
        startDate = nil
        
        WorkoutPersistence.clearWorkout()
    }
    
    func updateWorkout(_ workout: WorkoutTemplate) {
        currentWorkoutSubject.send(workout)
        persistWorkout()
    }
    
    private func saveCompletedWorkout(
        template: WorkoutTemplate?,
        startDate: Date?,
        duration: TimeInterval
    ) async {
        guard let template = template,
              let start = startDate else {
            return
        }
        
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
        
        do {
            try await workoutHistoryService.saveCompletedWorkout(completedWorkout)
        } catch {
        }
        
        if healthKitService.isHealthDataAvailable() {
            do {
                try await healthKitService.saveWorkout(completedWorkout)
            } catch {
            }
        }
    }
    
    private func persistWorkout() {
        guard let workout = currentWorkoutSubject.value, let start = startDate else { return }
        WorkoutPersistence.saveWorkout(workout, elapsedTime: elapsedTimeSubject.value, startDate: start)
    }
    
    private func loadPersistedWorkout() {
        guard let persisted = WorkoutPersistence.loadWorkout() else { return }
        
        currentWorkoutSubject.send(persisted.workout)
        startDate = persisted.startDate
        elapsedTimeSubject.send(persisted.elapsedTime)
        stateSubject.send(.minimized)
        
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let newTime = self.elapsedTimeSubject.value + 1
            self.elapsedTimeSubject.send(newTime)
            self.persistWorkout()
        }
    }
}

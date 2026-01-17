//
//  WorkoutManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import Combine
import Foundation

class WorkoutManager: WorkoutSessionProtocol, ObservableObject {
    
    static let shared = WorkoutManager()
    
    private var stateSubject: CurrentValueSubject<WorkoutState, Never>
    private var currentWorkoutSubject: CurrentValueSubject<WorkoutTemplate?, Never>
    private var elapsedTimeSubject: CurrentValueSubject<TimeInterval, Never>
    
    private var timer: Timer?
    private var startDate: Date?
    
    var statePublisher: AnyPublisher<WorkoutState, Never> { stateSubject.eraseToAnyPublisher() }
    var currentWorkoutPublisher: AnyPublisher<WorkoutTemplate?, Never> { currentWorkoutSubject.eraseToAnyPublisher() }
    var timerPublisher: AnyPublisher<TimeInterval, Never> { elapsedTimeSubject.eraseToAnyPublisher() }
    
    init() {
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
        timer?.invalidate()
        timer = nil
        persistWorkout()
    }
    
    func finishWorkout() {
        timer?.invalidate()
        timer = nil
        
        // TODO: Save to firebase
        stateSubject.send(.inactive)
        currentWorkoutSubject.send(nil)
        elapsedTimeSubject.send(0)
        startDate = nil
        
        WorkoutPersistence.clearWorkout()
        
        print("Manager: Workout Finished")
    }
    
    func discardWorkout() {
        timer?.invalidate()
        timer = nil
        
        stateSubject.send(.inactive)
        currentWorkoutSubject.send(nil)
        elapsedTimeSubject.send(0)
        startDate = nil
        
        WorkoutPersistence.clearWorkout()
        
        print("Manager: Workout Discarded")
    }
    
    func updateWorkout(_ workout: WorkoutTemplate) {
        currentWorkoutSubject.send(workout)
        persistWorkout()
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

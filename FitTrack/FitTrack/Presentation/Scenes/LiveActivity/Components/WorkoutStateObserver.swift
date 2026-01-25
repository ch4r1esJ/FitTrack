//
//  WorkoutStateObserver.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation
import Combine

class WorkoutStateObserver: ObservableObject {
    
    // MARK: - Properties
    
    @Published var hasActiveWorkout: Bool = false
    
    private let workoutStateRepository: WorkoutStateRepositoryProtocol
    private let liveActivityService: LiveActivityService?
    
    private var timer: Timer?
    
    // MARK: - Init
    
    init(
        workoutStateRepository: WorkoutStateRepositoryProtocol,
        liveActivityService: LiveActivityService?
    ) {
        self.workoutStateRepository = workoutStateRepository
        self.liveActivityService = liveActivityService
        
        checkWorkoutState()
        startObserving()
    }
    
    deinit {
        stopObserving()
    }
    
    // MARK: - Methods
    
    func checkWorkoutState() {
        hasActiveWorkout = workoutStateRepository.hasPersistedWorkout()
    }
    
    func markWorkoutDiscarded() {
        try? workoutStateRepository.clearWorkoutState()
        hasActiveWorkout = false
        
        if #available(iOS 16.1, *) {
            liveActivityService?.endWorkoutActivity()
        }
    }
    
    private func startObserving() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkWorkoutState()
        }
    }
    
    private func stopObserving() {
        timer?.invalidate()
        timer = nil
    }
}

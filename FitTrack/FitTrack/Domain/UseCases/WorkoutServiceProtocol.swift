//
//  WorkoutServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import Combine
import Foundation

protocol WorkoutSessionProtocol {
    var statePublisher: AnyPublisher<WorkoutState, Never> { get }
    var currentWorkoutPublisher: AnyPublisher<WorkoutTemplate?, Never> { get }
    var timerPublisher: AnyPublisher<TimeInterval, Never> { get }
    
    func startWorkout(template: WorkoutTemplate)
    func pauseWorkout()
    func resumeWorkout()
    func minimizeWorkout()
    func finishWorkout()
    func discardWorkout()
    func updateWorkout(_ workout: WorkoutTemplate)
}

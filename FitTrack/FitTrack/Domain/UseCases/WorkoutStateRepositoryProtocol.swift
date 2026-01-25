//
//  WorkoutStateRepositoryProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation

protocol WorkoutStateRepositoryProtocol {
    func saveWorkoutState(_ state: ActiveWorkoutState) throws
    func loadWorkoutState() throws -> ActiveWorkoutState?
    func clearWorkoutState() throws
    func hasPersistedWorkout() -> Bool
}













































































































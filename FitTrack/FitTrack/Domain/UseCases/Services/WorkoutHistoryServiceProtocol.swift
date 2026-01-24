//
//  WorkoutHistoryServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation

protocol WorkoutHistoryServiceProtocol {
    func saveCompletedWorkout(_ workout: CompletedWorkout) async throws
    func fetchUserWorkoutHistory(userId: String, limit: Int?) async throws -> [CompletedWorkout]
    func fetchWorkoutById(workoutId: String) async throws -> CompletedWorkout?
    func deleteWorkout(workoutId: String) async throws
}

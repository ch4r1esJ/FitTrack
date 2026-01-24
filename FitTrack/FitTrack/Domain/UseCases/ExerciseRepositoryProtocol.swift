//
//  ExerciseServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation

protocol ExerciseRepositoryProtocol {
    func fetchAllExercises() async throws -> [Exercise]
    func fetchUserCustomExercises(userId: String) async throws -> [Exercise]
    func createCustomExercise(_ exercise: Exercise, userId: String) async throws
    func deleteCustomExercise(exerciseId: String, userId: String) async throws
}

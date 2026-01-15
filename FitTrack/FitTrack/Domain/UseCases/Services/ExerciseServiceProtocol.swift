//
//  ExerciseServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation

protocol ExerciseServiceProtocol {
    func fetchAllExercises() async throws -> [Exercise]
}

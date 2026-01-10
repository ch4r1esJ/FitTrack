//
//  ExerciseData.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/10/26.
//

struct ExerciseData: Codable {
        let id: String
        let name: String
        let muscleGroup: String
        let equipment: String
        let difficulty: String
        let instructions: String
        let searchQuery: String
    }

//
//  WorkoutTemplate.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/11/26.
//

import Foundation

struct WorkoutTemplate: Identifiable, Codable {
    let id: String
    let name: String
    let exercises: [TemplateExercise]
    let createdAt: Date
    let userId: String
    
    var totalExercises: Int {
        exercises.count
    }
    
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }
}

struct TemplateExercise: Identifiable, Codable {
    var id: String
    var exerciseId: String
    var exerciseName: String
    var imageUrl: String?
    var muscleGroup: String
    var equipment: String
    var sets: [ExerciseSet]
}

struct ExerciseSet: Identifiable, Codable {
    var id: UUID = UUID()
    
    var setNumber: Int
    var targetWeightKg: Double?
    var targetReps: Int
    var restSeconds: Int
    
    enum CodingKeys: String, CodingKey {
        case setNumber
        case targetWeightKg
        case targetReps
        case restSeconds
    }
}

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
    let id: String
    let exerciseId: String
    let exerciseName: String
    let muscleGroup: String
    let equipment: String
    let sets: [ExerciseSet]
}

struct ExerciseSet: Codable {
    let setNumber: Int
    let targetWeightKg: Double?
    let targetReps: Int
    let restSeconds: Int
    
    var restDisplay: String {
        let minutes = restSeconds / 60
        let seconds = restSeconds % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }
}

//
//  WorkoutTemplate.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/11/26.
//

import Foundation

struct WorkoutTemplate: Identifiable {
    let id: String
    let name: String
    let exercises: [TemplateExercise]
    let createdAt: Date
    let userId: String
    
    var totalExercises: Int {
        exercises.count
    }
    
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets }
    }
}

struct TemplateExercise: Identifiable {
    let id: String
    let exerciseId: String
    let exerciseName: String
    let muscleGroup: String
    let equipment: String
    let sets: Int
    let targetRepsMin: Int
    let targetRepsMax: Int
    let restSeconds: Int
    let notes: String?
    
    var repsDisplay: String {
        if targetRepsMin == targetRepsMax {
            return "\(targetRepsMin) reps"
        } else {
            return "\(targetRepsMin)-\(targetRepsMax) reps"
        }
    }
    
    var restDisplay: String {
        let minutes = restSeconds / 60
        let seconds = restSeconds % 60
        if minutes > 0 && seconds > 0 {
            return "\(minutes)m \(seconds)s"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}

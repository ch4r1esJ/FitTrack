//
//  CompletedWorkout.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation

struct CompletedWorkout: Identifiable, Codable {
    let id: String
    let templateId: String
    let templateName: String
    let userId: String
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let exercises: [CompletedExercise]
    let totalVolume: Double
    let totalSets: Int
    let completedSets: Int
    
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }
}

struct CompletedExercise: Identifiable, Codable {
    let id: String
    let exerciseId: String
    let exerciseName: String
    let muscleGroup: String
    let equipment: String
    let sets: [CompletedSet]
    
    var totalVolume: Double {
        sets.reduce(0) { total, set in
            total + ((set.actualWeightKg ?? 0) * Double(set.actualReps ?? 0))
        }
    }
}

struct CompletedSet: Identifiable, Codable {
    let id: UUID
    let setNumber: Int
    let targetWeightKg: Double?
    let targetReps: Int?
    let actualWeightKg: Double?
    let actualReps: Int?
    let isCompleted: Bool
}

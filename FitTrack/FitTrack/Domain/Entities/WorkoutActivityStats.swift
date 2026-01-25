//
//  WorkoutActivityStats.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation

struct WorkoutActivityStats: Sendable {
    let type: WorkoutType
    let durationMinutes: Int
    
    enum WorkoutType: Hashable, Sendable {
        case running
        case walking
        case cycling
        case strength
        case yoga
        case hiit
    }
}

struct WorkoutSummary: Sendable {
    let title: String
    let imageName: String
    let color: String
    let durationMinutes: Int
    let date: Date
    let calories: Double?
    let isFromFitTrack: Bool
}

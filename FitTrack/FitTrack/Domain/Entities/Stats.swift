//
//  WeeklyWorkoutData.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import Foundation

struct WeeklyWorkoutData: Identifiable {
    let id = UUID()
    let weekLabel: String
    let count: Int
    let weekStart: Date
}

struct WeeklyVolumeData: Identifiable {
    let id = UUID()
    let weekLabel: String
    let volume: Double
    let weekStart: Date
}

struct MuscleGroupData: Identifiable {
    let id = UUID()
    let muscleGroup: String
    let count: Int
    let percentage: Int
}

struct PersonalRecord: Identifiable {
    let id: String
    let exerciseName: String
    let weight: Double
    let reps: Int
    let date: Date
}

struct DayDurationData: Identifiable {
    let id = UUID()
    let dayName: String
    let averageDuration: Double
    let weekday: Int
}

struct WeekDurationData: Identifiable {
    let id = UUID()
    let weekLabel: String
    let totalDuration: Double
    let weekStart: Date
}

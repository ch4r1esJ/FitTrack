//
//  HealthKitActivityRepositoryProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation
import HealthKit

protocol HealthKitActivityRepositoryProtocol {
    func requestAuthorization() async throws
    func fetchActivitySummary() async throws -> HKActivitySummary
    func fetchTodayCalories() async throws -> Double
    func fetchTodayExerciseTime() async throws -> Double
    func fetchTodayStandHours() async throws -> Int
    func fetchTodaySteps() async throws -> Double
    func fetchCurrentWeekWorkoutStats() async throws -> [WorkoutActivityStats]
    func fetchWorkoutsForMonth(_ date: Date) async throws -> [WorkoutSummary]
}

//
//  HealthKitActivityRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation
import HealthKit

class HealthKitActivityRepository: HealthKitActivityRepositoryProtocol {
    
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        let activitySummary = HKObjectType.activitySummaryType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts, activitySummary]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchActivitySummary() async throws -> HKActivitySummary {
        return try await withCheckedThrowingContinuation { continuation in
            let calendar = Calendar.current
            var components = calendar.dateComponents([.day, .month, .year, .era], from: Date())
            components.calendar = calendar
            
            let predicate = HKQuery.predicateForActivitySummary(with: components)
            
            let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let summary = summaries?.first {
                    continuation.resume(returning: summary)
                } else {
                    continuation.resume(throwing: HealthKitActivityError.noData)
                }
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayCalories() async throws -> Double {
        return try await withCheckedThrowingContinuation { continuation in
            let calories = HKQuantityType(.activeEnergyBurned)
            let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
            
            let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let quantity = results?.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let calorieCount = quantity.doubleValue(for: .kilocalorie())
                continuation.resume(returning: calorieCount)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayExerciseTime() async throws -> Double {
        return try await withCheckedThrowingContinuation { continuation in
            let exercise = HKQuantityType(.appleExerciseTime)
            let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
            
            let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let quantity = results?.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let exerciseTime = quantity.doubleValue(for: .minute())
                continuation.resume(returning: exerciseTime)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodayStandHours() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            let stand = HKCategoryType(.appleStandHour)
            let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
            
            let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = results as? [HKCategorySample] else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let standCount = samples.filter({ $0.value == 0 }).count
                continuation.resume(returning: standCount)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchTodaySteps() async throws -> Double {
        return try await withCheckedThrowingContinuation { continuation in
            let steps = HKQuantityType(.stepCount)
            let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
            
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let quantity = results?.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let steps = quantity.doubleValue(for: .count())
                continuation.resume(returning: steps)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchCurrentWeekWorkoutStats() async throws -> [WorkoutActivityStats] {
        return try await withCheckedThrowingContinuation { continuation in
            let workouts = HKSampleType.workoutType()
            let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
            
            let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let workouts = results as? [HKWorkout] else {
                    continuation.resume(returning: [])
                    return
                }
                
                var stats: [WorkoutActivityStats.WorkoutType: Int] = [:]
                
                for workout in workouts {
                    let duration = Int(workout.duration) / 60
                    
                    switch workout.workoutActivityType {
                    case .running:
                        stats[.running, default: 0] += duration
                    case .walking:
                        stats[.walking, default: 0] += duration
                    case .cycling:
                        stats[.cycling, default: 0] += duration
                    case .traditionalStrengthTraining, .functionalStrengthTraining:
                        stats[.strength, default: 0] += duration
                    case .yoga:
                        stats[.yoga, default: 0] += duration
                    case .highIntensityIntervalTraining:
                        stats[.hiit, default: 0] += duration
                    default:
                        break
                    }
                }
                
                let result = [
                    WorkoutActivityStats(type: .running, durationMinutes: stats[.running, default: 0]),
                    WorkoutActivityStats(type: .walking, durationMinutes: stats[.walking, default: 0]),
                    WorkoutActivityStats(type: .cycling, durationMinutes: stats[.cycling, default: 0]),
                    WorkoutActivityStats(type: .strength, durationMinutes: stats[.strength, default: 0]),
                    WorkoutActivityStats(type: .yoga, durationMinutes: stats[.yoga, default: 0]),
                    WorkoutActivityStats(type: .hiit, durationMinutes: stats[.hiit, default: 0])
                ]
                
                continuation.resume(returning: result)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchWorkoutsForMonth(_ date: Date) async throws -> [WorkoutSummary] {
        return try await withCheckedThrowingContinuation { continuation in
            let workouts = HKSampleType.workoutType()
            let (startDate, endDate) = date.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let workouts = results as? [HKWorkout] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let summaries = workouts.map { workout in
                    let appName = workout.metadata?["AppName"] as? String
                    let templateName = workout.metadata?[HKMetadataKeyWorkoutBrandName] as? String
                    let isFromFitTrack = (appName == "FitTrack")
                    
                    let title: String
                    if isFromFitTrack, let template = templateName {
                        title = "FitTrack - \(template)"
                    } else {
                        title = workout.workoutActivityType.name
                    }
                    
                    return WorkoutSummary(
                        title: title,
                        imageName: workout.workoutActivityType.image,
                        color: workout.workoutActivityType.colorName,
                        durationMinutes: Int(workout.duration) / 60,
                        date: workout.startDate,
                        calories: workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()),
                        isFromFitTrack: isFromFitTrack
                    )
                }
                
                continuation.resume(returning: summaries)
            }
            
            healthStore.execute(query)
        }
    }
}

enum HealthKitActivityError: Error {
    case noData
    case authorizationDenied
    
    var localizedDescription: String {
        switch self {
        case .noData:
            return "No activity data available"
        case .authorizationDenied:
            return "HealthKit authorization was denied"
        }
    }
}

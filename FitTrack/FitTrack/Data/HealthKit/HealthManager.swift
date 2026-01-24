//
//  HealthManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import Foundation
import HealthKit
import SwiftUI

extension Date {
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
    }
    
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        let calendar = Calendar.current
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    func monthAndYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: self)
    }
}

extension Double {
    func formattedNumbersString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

class HealthManager {
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init () {
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        let activitySummary = HKObjectType.activitySummaryType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts, activitySummary]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func startObservingActivitySummary(onUpdate: @escaping (Result<HKActivitySummary, Error>) -> Void) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year, .era], from: Date())
        components.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }
            
            if let summary = summaries?.first {
                onUpdate(.success(summary))
            }
        }
        
        query.updateHandler = { _, summaries, error in
            if let summary = summaries?.first {
                onUpdate(.success(summary))
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.success(0))
                
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.success(0))
                
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.success(0))
                
                return
            }
            
            let standCount = samples.filter({ $0.value == 0}).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
        
    func fetchTodaySteps(completion: @escaping(Result<Activities, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error ?? NSError()))
                
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let activity = Activities(title: "Today Steps", subtitle: "Goal: 10000", image: "figure.walk", tintColor: .green, amount: steps.formattedNumbersString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activities], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var runningCount: Int = 0
            var walkingCount: Int = 0
            var cyclingCount: Int = 0
            var strengthCount: Int = 0
            var yogaCount: Int = 0
            var hiitCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                
                switch workout.workoutActivityType {
                case .running:
                    runningCount += duration
                case .walking:
                    walkingCount += duration
                case .cycling:
                    cyclingCount += duration
                case .traditionalStrengthTraining, .functionalStrengthTraining:
                    strengthCount += duration
                case .yoga:
                    yogaCount += duration
                case .highIntensityIntervalTraining:
                    hiitCount += duration
                default:
                    break
                }
            }
            
            completion(.success(generateActivitiesFromDurations(
                running: runningCount,
                walking: walkingCount,
                cycling: cyclingCount,
                strength: strengthCount,
                yoga: yogaCount,
                hiit: hiitCount
            )))
        }
        
        healthStore.execute(query)
    }
    
    func generateActivitiesFromDurations(running: Int, walking: Int, cycling: Int, strength: Int, yoga: Int, hiit: Int) -> [Activities] {
        return [
            Activities(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) min"),
            Activities(title: "Walking", subtitle: "This week", image: "figure.walk", tintColor: .orange, amount: "\(walking) min"),
            Activities(title: "Cycling", subtitle: "This week", image: "figure.outdoor.cycle", tintColor: .blue, amount: "\(cycling) min"),
            Activities(title: "Strength", subtitle: "This week", image: "dumbbell.fill", tintColor: .red, amount: "\(strength) min"),
            Activities(title: "Yoga", subtitle: "This week", image: "figure.yoga", tintColor: .purple, amount: "\(yoga) min"),
            Activities(title: "HIIT", subtitle: "This week", image: "figure.cross.training", tintColor: .yellow, amount: "\(hiit) min")
        ]
    }
        
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let workoutsArray = workouts.map { workout in
                let appName = workout.metadata?["AppName"] as? String
                let templateName = workout.metadata?[HKMetadataKeyWorkoutBrandName] as? String
                
                let isFromFitTrack = (appName == "FitTrack")
                let title: String
                
                if isFromFitTrack, let template = templateName {
                    title = "FitTrack - \(template)"
                } else {
                    title = workout.workoutActivityType.name
                }
                
                return Workout(
                    title: title,
                    image: workout.workoutActivityType.image,
                    tintcolor: workout.workoutActivityType.color,
                    duration: "\(Int(workout.duration)/60) min",
                    date: workout.startDate,
                    calories: (workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumbersString() ?? "-") + " kcal",
                    isFromFitTrack: isFromFitTrack
                )
            }
            
            completion(.success(workoutsArray))
        }
        
        healthStore.execute(query)
    }
}

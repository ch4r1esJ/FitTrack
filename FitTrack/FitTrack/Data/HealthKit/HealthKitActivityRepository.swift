//
//  HealthKitActivityRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitActivityRepository: HealthKitActivityRepositoryProtocol {
    
    private let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Result<Void, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        let activitySummary = HKObjectType.activitySummaryType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts, activitySummary]
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { success, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchActivitySummary(completion: @escaping (Result<HKActivitySummary, Error>) -> Void) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year, .era], from: Date())
        components.calendar = calendar
        
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { _, summaries, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let summary = summaries?.first {
                completion(.success(summary))
            } else {
                completion(.failure(HealthKitActivityError.noData))
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaySteps(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.success(0))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activities], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let workouts = results as? [HKWorkout] else {
                completion(.success([]))
                return
            }
            
            var runningMins = 0
            var walkingMins = 0
            var cyclingMins = 0
            var strengthMins = 0
            var yogaMins = 0
            var hiitMins = 0
            
            for workout in workouts {
                let duration = Int(workout.duration) / 60
                
                switch workout.workoutActivityType {
                case .running:
                    runningMins += duration
                case .walking:
                    walkingMins += duration
                case .cycling:
                    cyclingMins += duration
                case .traditionalStrengthTraining, .functionalStrengthTraining:
                    strengthMins += duration
                case .yoga:
                    yogaMins += duration
                case .highIntensityIntervalTraining:
                    hiitMins += duration
                default:
                    break
                }
            }
            
            let activities = [
                Activities(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(runningMins) min"),
                Activities(title: "Walking", subtitle: "This week", image: "figure.walk", tintColor: .orange, amount: "\(walkingMins) min"),
                Activities(title: "Cycling", subtitle: "This week", image: "figure.outdoor.cycle", tintColor: .blue, amount: "\(cyclingMins) min"),
                Activities(title: "Strength", subtitle: "This week", image: "dumbbell.fill", tintColor: .red, amount: "\(strengthMins) min"),
                Activities(title: "Yoga", subtitle: "This week", image: "figure.yoga", tintColor: .purple, amount: "\(yogaMins) min"),
                Activities(title: "HIIT", subtitle: "This week", image: "figure.cross.training", tintColor: .yellow, amount: "\(hiitMins) min")
            ]
            
            completion(.success(activities))
        }
        
        healthStore.execute(query)
    }
    
    func fetchWorkoutsForMonth(_ date: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = date.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let workouts = results as? [HKWorkout] else {
                completion(.success([]))
                return
            }
            
            let workoutArray = workouts.map { workout in
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
                    duration: "\(Int(workout.duration) / 60) min",
                    date: workout.startDate,
                    calories: (workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumbersString() ?? "---") + " kcal",
                    isFromFitTrack: isFromFitTrack
                )
            }
            
            completion(.success(workoutArray))
        }
        
        healthStore.execute(query)
    }
}

enum HealthKitActivityError: Error {
    case noData
    case authorizationDenied
}

//
//  HealthKitService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation
import HealthKit

class HealthKitService: HealthKitServiceProtocol {
    
    private let healthStore = HKHealthStore()
    
    func isHealthDataAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization() async throws {
        guard isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }
    
    func saveWorkout(_ workout: CompletedWorkout) async throws {
        guard isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        
        let workoutType = HKObjectType.workoutType()
        let authStatus = healthStore.authorizationStatus(for: workoutType)
        
        if authStatus == .notDetermined {
            try await requestAuthorization()
        } else if authStatus == .sharingDenied {
            throw HealthKitError.authorizationDenied
        }
        
        let estimatedCalories = calculateEstimatedCalories(for: workout)
        
        var metadata: [String: Any] = [
            HKMetadataKeyIndoorWorkout: true,
            HKMetadataKeyWorkoutBrandName: workout.templateName,
            "AppName": "FitTrack",
            "TotalVolume": "\(Int(workout.totalVolume)) kg",
            "TotalSets": workout.totalSets,
            "CompletedSets": workout.completedSets,
            "Exercises": workout.exercises.map { $0.exerciseName }.joined(separator: ", ")
        ]
        
        let hkWorkout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: workout.startDate,
            end: workout.endDate,
            duration: workout.duration,
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: estimatedCalories),
            totalDistance: nil,
            metadata: metadata
        )
        
        try await healthStore.save(hkWorkout)
        
        try await saveCaloriesSample(
            calories: estimatedCalories,
            start: workout.startDate,
            end: workout.endDate,
            workout: hkWorkout
        )
    }
    
    private func saveCaloriesSample(
        calories: Double,
        start: Date,
        end: Date,
        workout: HKWorkout
    ) async throws {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        
        let energyQuantity = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        
        let energySample = HKQuantitySample(
            type: energyType,
            quantity: energyQuantity,
            start: start,
            end: end,
            metadata: nil
        )
        
        try await healthStore.save(energySample)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.add([energySample], to: workout) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: HealthKitError.saveFailed)
                }
            }
        }
    }
    
    private func calculateEstimatedCalories(for workout: CompletedWorkout) -> Double {
        let caloriesPerMinute = 4.5
        let durationInMinutes = workout.duration / 60.0
        let volumeBonus = min(workout.totalVolume / 1000.0 * 10, 50)
        
        return (caloriesPerMinute * durationInMinutes) + volumeBonus
    }
}

enum HealthKitError: Error {
    case notAvailable
    case authorizationDenied
    case authorizationFailed
    case saveFailed
    
    var localizedDescription: String {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .authorizationDenied:
            return "HealthKit authorization was denied. Please enable it in Settings > Health > Data Access & Devices"
        case .authorizationFailed:
            return "Failed to authorize HealthKit"
        case .saveFailed:
            return "Failed to save workout to HealthKit"
        }
    }
}

//
//  HealthKitService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation
import HealthKit

class HealthKitService: HealthKitRepositoryProtocol {
    
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
        
        let metadata: [String: Any] = [
            HKMetadataKeyIndoorWorkout: true,
            HKMetadataKeyWorkoutBrandName: workout.templateName,
            "AppName": "FitTrack",
            "TotalVolume": "\(Int(workout.totalVolume)) kg",
            "TotalSets": workout.totalSets,
            "CompletedSets": workout.completedSets,
            "Exercises": workout.exercises.map { $0.exerciseName }.joined(separator: ", ")
        ]
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor
        
        let builder = HKWorkoutBuilder(
            healthStore: healthStore,
            configuration: configuration,
            device: .local()
        )
        
        try await builder.beginCollection(at: workout.startDate)
        
        let energyType = HKQuantityType(.activeEnergyBurned)
        let energyQuantity = HKQuantity(unit: .kilocalorie(), doubleValue: estimatedCalories)
        let energySample = HKQuantitySample(
            type: energyType,
            quantity: energyQuantity,
            start: workout.startDate,
            end: workout.endDate
        )
        
        try await builder.addSamples([energySample])
        
        try await builder.addMetadata(metadata)
        
        try await builder.endCollection(at: workout.endDate)
        try await builder.finishWorkout()
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

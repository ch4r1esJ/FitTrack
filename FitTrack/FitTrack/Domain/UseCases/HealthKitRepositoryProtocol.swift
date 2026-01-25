//
//  HealthKitServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation

protocol HealthKitRepositoryProtocol {
    func requestAuthorization() async throws
    func saveWorkout(_ workout: CompletedWorkout) async throws
    func isHealthDataAvailable() -> Bool
}

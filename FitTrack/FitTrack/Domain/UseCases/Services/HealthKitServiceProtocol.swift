//
//  HealthKitServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation

protocol HealthKitServiceProtocol {
    func requestAuthorization() async throws
    func saveWorkout(_ workout: CompletedWorkout) async throws
    func isHealthDataAvailable() -> Bool
}

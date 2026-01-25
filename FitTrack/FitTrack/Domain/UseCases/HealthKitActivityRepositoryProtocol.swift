//
//  HealthKitActivityRepositoryProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation
import HealthKit

protocol HealthKitActivityRepositoryProtocol {
    func requestAuthorization(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchActivitySummary(completion: @escaping (Result<HKActivitySummary, Error>) -> Void)
    func fetchTodaySteps(completion: @escaping (Result<Double, Error>) -> Void)
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activities], Error>) -> Void)
    func fetchWorkoutsForMonth(_ date: Date, completion: @escaping (Result<[Workout], Error>) -> Void)
}

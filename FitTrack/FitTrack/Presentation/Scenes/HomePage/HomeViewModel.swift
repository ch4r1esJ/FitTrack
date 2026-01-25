//
//  HomeViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import SwiftUI
import Combine
import HealthKit

class HomeViewModel: ObservableObject {
    
    private let healthKitActivityRepository: HealthKitActivityRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userName: String = ""
    @Published var profileImage: String = "avatar1"
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    
    @Published var calorieGoal: Int = 500
    @Published var exerciseGoal: Int = 30
    @Published var standGoal: Int = 12
    
    @Published var activities = [Activities]()
    @Published var workouts = [Workout]()
    
    init(
        healthKitActivityRepository: HealthKitActivityRepositoryProtocol,
        authRepository: AuthRepositoryProtocol
    ) {
        self.healthKitActivityRepository = healthKitActivityRepository
        self.authRepository = authRepository
        
        fetchUserName()
        fetchProfileImage()
        
        healthKitActivityRepository.requestAuthorization { [weak self] result in
            if case .success = result {
                self?.fetchAllHealthData()
            }
        }
    }
    
    func refresh() {
        fetchUserName()
        fetchProfileImage()
        fetchAllHealthData()
    }
    
    func fetchProfileImage() {
        if let savedImage = UserDefaults.standard.string(forKey: "profileImage") {
            self.profileImage = savedImage
        } else {
            self.profileImage = "avatar1"
        }
    }
    
    func checkForImageUpdate() {
        if let updatedImage = UserDefaults.standard.string(forKey: "profileImage"),
           updatedImage != profileImage {
            self.profileImage = updatedImage
        }
    }
    
    func checkForNameUpdate() {
        if let updatedName = UserDefaults.standard.string(forKey: "profileName"),
           updatedName != userName {
            self.userName = updatedName
        }
    }
    
    var userFirstName: String {
        userName.components(separatedBy: " ").first ?? userName
    }
    
    func fetchUserName() {
        if let user = authRepository.currentUser {
            self.userName = user.name
        } else {
            self.userName = "Guest"
        }
    }
    
    private func fetchAllHealthData() {
        DispatchQueue.main.async {
            self.activities = []
        }
        
        fetchActivityRings()
        fetchTodaysSteps()
        fetchCurrentWeekActivities()
        fetchRecentWorkouts()
    }
    
    private func fetchActivityRings() {
        healthKitActivityRepository.fetchActivitySummary { [weak self] result in
            if case .success(let summary) = result {
                DispatchQueue.main.async {
                    let calValue = summary.activeEnergyBurned.doubleValue(for: .kilocalorie())
                    let exValue = summary.appleExerciseTime.doubleValue(for: .minute())
                    let standValue = summary.appleStandHours.doubleValue(for: .count())
                    
                    let calGoal = summary.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
                    let exGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
                    let standGoal = summary.appleStandHoursGoal.doubleValue(for: .count())
                    
                    withAnimation {
                        self?.calories = Int(calValue)
                        self?.exercise = Int(exValue)
                        self?.stand = Int(standValue)
                        
                        self?.calorieGoal = Int(calGoal)
                        self?.exerciseGoal = Int(exGoal)
                        self?.standGoal = Int(standGoal)
                    }
                    
                    let activity = Activities(
                        title: "Today calories",
                        subtitle: "Goal: \(Int(calGoal))",
                        image: "flame",
                        tintColor: .red,
                        amount: calValue.formattedNumbersString()
                    )
                    self?.activities.append(activity)
                }
            }
        }
    }
    
    private func fetchTodaysSteps() {
        healthKitActivityRepository.fetchTodaySteps { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let steps) = result {
                    let activity = Activities(
                        title: "Today Steps",
                        subtitle: "Goal: 10000",
                        image: "figure.walk",
                        tintColor: .green,
                        amount: steps.formattedNumbersString()
                    )
                    self?.activities.append(activity)
                } else {
                    let activity = Activities(
                        title: "Today Steps",
                        subtitle: "Goal: 10000",
                        image: "figure.walk",
                        tintColor: .green,
                        amount: "---"
                    )
                    self?.activities.append(activity)
                }
            }
        }
    }
    
    private func fetchCurrentWeekActivities() {
        healthKitActivityRepository.fetchCurrentWeekWorkoutStats { [weak self] result in
            if case .success(let weekActivities) = result {
                DispatchQueue.main.async {
                    self?.activities.append(contentsOf: weekActivities)
                }
            }
        }
    }
    
    private func fetchRecentWorkouts() {
        healthKitActivityRepository.fetchWorkoutsForMonth(Date()) { [weak self] result in
            if case .success(let allWorkouts) = result {
                DispatchQueue.main.async {
                    self?.workouts = Array(allWorkouts.prefix(4))
                }
            }
        }
    }
}

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
        
        Task {
            fetchUserName()
            fetchProfileImage()
            
            do {
                try await healthKitActivityRepository.requestAuthorization()
                await fetchAllHealthData()
            } catch {
            }
        }
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
    
    private func fetchAllHealthData() async {
        await fetchActivityRings()
        await fetchTodaysSteps()
        await fetchCurrentWeekActivities()
        await fetchRecentWorkouts()
    }
    
    private func fetchActivityRings() async {
        do {
            let summary = try await healthKitActivityRepository.fetchActivitySummary()
            
            await MainActor.run {
                let calValue = summary.activeEnergyBurned.doubleValue(for: .kilocalorie())
                let exValue = summary.appleExerciseTime.doubleValue(for: .minute())
                let standValue = summary.appleStandHours.doubleValue(for: .count())
                
                let calGoal = summary.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())
                let exGoal = summary.appleExerciseTimeGoal.doubleValue(for: .minute())
                let standGoal = summary.appleStandHoursGoal.doubleValue(for: .count())
                
                withAnimation {
                    self.calories = Int(calValue)
                    self.exercise = Int(exValue)
                    self.stand = Int(standValue)
                    
                    self.calorieGoal = Int(calGoal)
                    self.exerciseGoal = Int(exGoal)
                    self.standGoal = Int(standGoal)
                }
                
                self.activities.removeAll(where: { $0.title == "Today calories" })
                
                let activity = Activities(
                    title: "Today calories",
                    subtitle: "Goal: \(Int(calGoal))",
                    image: "flame",
                    tintColor: .red,
                    amount: calValue.formattedNumbersString()
                )
                self.activities.append(activity)
            }
        } catch {
        }
    }
    
    private func fetchTodaysSteps() async {
        do {
            let steps = try await healthKitActivityRepository.fetchTodaySteps()
            
            await MainActor.run {
                let activity = Activities(
                    title: "Today Steps",
                    subtitle: "Goal: 10000",
                    image: "figure.walk",
                    tintColor: .green,
                    amount: steps.formattedNumbersString()
                )
                self.activities.append(activity)
            }
        } catch {
            await MainActor.run {
                let activity = Activities(
                    title: "Today Steps",
                    subtitle: "Goal: 10000",
                    image: "figure.walk",
                    tintColor: .green,
                    amount: "---"
                )
                self.activities.append(activity)
            }
        }
    }
    
    private func fetchCurrentWeekActivities() async {
        do {
            let stats = try await healthKitActivityRepository.fetchCurrentWeekWorkoutStats()
            
            await MainActor.run {
                let activities = stats.map { stat -> Activities in
                    let (title, image, color) = stat.type.displayInfo
                    return Activities(
                        title: title,
                        subtitle: "This week",
                        image: image,
                        tintColor: color,
                        amount: "\(stat.durationMinutes) min"
                    )
                }
                self.activities.append(contentsOf: activities)
            }
        } catch {
        }
    }
    
    private func fetchRecentWorkouts() async {
        do {
            let workoutSummaries = try await healthKitActivityRepository.fetchWorkoutsForMonth(Date())
            
            await MainActor.run {
                self.workouts = Array(workoutSummaries.prefix(4)).map { summary in
                    Workout(
                        title: summary.title,
                        image: summary.imageName,
                        tintcolor: summary.color.toColor(),
                        duration: "\(summary.durationMinutes) min",
                        date: summary.date,
                        calories: summary.calories.map { "\($0.formattedNumbersString()) kcal" } ?? "---",
                        isFromFitTrack: summary.isFromFitTrack
                    )
                }
            }
        } catch {
        }
    }
}

//
//  HomeView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Combine
import HealthKit

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    private let authService = FirebaseAuthService()
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
    
    init() {
        Task {
            fetchUserName()
            fetchProfileImage()
            do {
                try await healthManager.requestHealthKitAccess()
//                fetchTodayCalories()
                fetchActivityRings()
//                fetchTodayExerciseTime()
//                fetchTodayStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivities()
                fetchRecentWorkouts()
            } catch {
                print(error.localizedDescription)
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
            if let user = authService.currentUser {
                self.userName = user.name
            } else {
                self.userName = "Guest"
            }
        }
    
    func fetchActivityRings() {
            healthManager.startObservingActivitySummary { result in
                switch result {
                case .success(let summary):
                    DispatchQueue.main.async {
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
                    
                case .failure(let error):
                    print("Failed to fetch summary: \(error.localizedDescription)")
                }
            }
        }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                    let activity = Activities(title: "Today calories", subtitle: "today", image: "flame", tintColor: .red, amount: calories.formattedNumbersString())
                    self.activities.append(activity)
                }

            case .failure(let failure):
                DispatchQueue.main.async {
                    let activity = Activities(title: "Today calories", subtitle: "today", image: "flame", tintColor: .red, amount: "---")
                    self.activities.append(activity)
                }
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }

            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = Int(hours)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchTodaysSteps() {
        healthManager.fetchTodaySteps { result in
            switch result {
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.activities.append(Activities(title: "Today Steps", subtitle: "Goal: 10000", image: "figure.walk", tintColor: .green, amount: "---"))
                }
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchCurrentWeekActivities() {
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result {
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var onProfileTapped: (() -> Void)?
    @State var showAllActivities = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Welcome, \(viewModel.userFirstName)")
                            .font(.largeTitle)
                            .padding()
                        
                        Button(action: {
                            onProfileTapped?()
                        }) {
                            Image(viewModel.profileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                )
                        }
                        .padding(.trailing)
                    }
                    
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.red)
                                
                                Text("\(viewModel.calories) / \(viewModel.calorieGoal)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.green )
                                
                                Text("\(viewModel.exercise) / \(viewModel.exerciseGoal)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundStyle(.blue )
                                
                                Text("\(viewModel.stand) / \(viewModel.standGoal)")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: viewModel.calorieGoal, color: .red)
                            
                            ProgressCircleView(progress: $viewModel.exercise, goal: viewModel.exerciseGoal, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $viewModel.stand, goal: viewModel.standGoal, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showAllActivities.toggle()
                            }
                        } label: {
                            Text(showAllActivities ? "Show less" : "Show more")
                                .padding(.all, 10)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            
                            ForEach(showAllActivities ? viewModel.activities : Array(viewModel.activities.prefix(4)), id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        Text("Recent Workouts")
                            .font(.title2)
                        
                        Spacer()
                        
                        NavigationLink {
                            MonthWorkoutsView()
                        } label: {
                            Text("Show more")
                                .padding(.all, 10)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(viewModel.workouts) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding(.bottom)
                    
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            viewModel.checkForNameUpdate()
            viewModel.checkForImageUpdate()
        }
    }
}

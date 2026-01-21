//
//  HomeView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    
    @Published var activities = [Activities]()
    @Published var workouts = [Workout]()
    
    var mockActivities = [
        Activities(title: "Morning Run", subtitle: "Cardio", image: "figure.run", tintColor: .green, amount: "5.2 km"),
        Activities(title: "Deep Sleep", subtitle: "Rest", image: "moon.stars.fill", tintColor: .indigo, amount: "7h 20m"),
        Activities(title: "Water Intake", subtitle: "Hydration", image: "drop.fill", tintColor: .blue, amount: "1.5 Liters"),
        Activities(title: "Read Book", subtitle: "Education", image: "book.fill", tintColor: .orange, amount: "45 Pages"), ]
    
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivities()
                fetchRecentWorkouts()
            } catch {
                print(error.localizedDescription)
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
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewModel.calories)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green )
                                
                                Text("\(viewModel.exercise)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green )
                                
                                Text("\(viewModel.stand)")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .blue)
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
                            print("show more")
                        } label: {
                            Text("Show more")
                                .padding(.all, 10)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            ForEach(viewModel.activities, id: \.title) { activity in
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
                            EmptyView()
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
    }
}

#Preview {
    HomeView()
}

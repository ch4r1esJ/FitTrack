//
//  HomeView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    @State var showAllActivities = false
    
    @State var showMonthWorkouts = false
    
    var onProfileTapped: (() -> Void)?
    
    let backgroundColor = Color(uiColor: .systemGray6)
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
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
                                ActivityRingsStatistics(
                                    title: "Calories",
                                    color: .red,
                                    calories: viewModel.calories,
                                    caloriesGoal: viewModel.calorieGoal
                                )
                                .padding(.bottom)
                                
                                ActivityRingsStatistics(
                                    title: "Active",
                                    color: .green,
                                    calories: viewModel.exercise,
                                    caloriesGoal: viewModel.exerciseGoal
                                )
                                .padding(.bottom)
                                
                                ActivityRingsStatistics(
                                    title: "Stand",
                                    color: .blue,
                                    calories: viewModel.stand,
                                    caloriesGoal: viewModel.standGoal
                                )
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
                                
                                ForEach(showAllActivities ? viewModel.activities : viewModel.activities) { activity in
                                    ActivityCard(activity: activity)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            Text("Recent Workouts")
                                .font(.title2)
                            
                            Spacer()
                            
                            Button {
                                showMonthWorkouts = true
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
            .navigationDestination(isPresented: $showMonthWorkouts) {
                MonthWorkoutsView(
                    viewModel: MonthWorkoutsViewModel(
                        healthKitActivityRepository: HealthKitActivityRepository()
                    )
                )
            }
        }
        .onAppear {
            viewModel.refresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            viewModel.checkForNameUpdate()
            viewModel.checkForImageUpdate()
        }
    }
}

struct ActivityRingsStatistics: View {
    var title: String
    var color: Color
    var calories: Int
    var caloriesGoal: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundStyle(color)
            
            Text("\(calories) / \(caloriesGoal)")
                .bold()
        }
    }
}

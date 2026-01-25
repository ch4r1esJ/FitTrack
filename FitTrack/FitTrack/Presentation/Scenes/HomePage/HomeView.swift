//
//  HomeView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    var onProfileTapped: (() -> Void)?
    @State var showAllActivities = false
    @State var showMonthWorkouts = false
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
                                ForEach(showAllActivities ? viewModel.activities : Array(viewModel.activities.prefix(4))) { activity in
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

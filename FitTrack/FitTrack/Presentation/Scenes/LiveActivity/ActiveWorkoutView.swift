//
//  ActiveWorkoutView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct ActiveWorkoutView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var onAddExerciseTapped: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("ACTIVE WORKOUT")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fontWeight(.bold)
                        
                        Text(viewModel.currentWorkout.name)
                            .font(.title2)
                            .fontWeight(.heavy)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.elapsedTime)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                    
                    Button(action: { viewModel.minimizeWorkout() }) {
                        Image(systemName: "chevron.down")
                            .padding(10)
                            .background(Color(.systemGray5))
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach($viewModel.currentWorkout.exercises) { $exercise in
                            ActiveExerciseCard(
                                exercise: $exercise,
                                viewModel: viewModel,
                                onDelete: {
                                    withAnimation {
                                        viewModel.deleteExercise(exercise)
                                    }
                                }
                            )
                        }
                        
                        addExerciseButton
                            .padding(.vertical)
                        
                        if viewModel.restTimer.isActive {
                            Color.clear.frame(height: 200)
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                
                if !viewModel.restTimer.isActive {
                    VStack {
                        Button(action: { viewModel.finishWorkout() }) {
                            Text("FINISH WORKOUT")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .shadow(radius: 5)
                }
            }
            
            if viewModel.restTimer.isActive {
                RestTimerView(restTimer: viewModel.restTimer)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.restTimer.isActive)
        .onAppear {
            viewModel.resumeTimerIfNeeded()
            NotificationManager.shared.requestPermission()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.restTimer.resumeIfNeeded()
            }
        }
    }
    
    var addExerciseButton: some View {
        Button(action: {
            onAddExerciseTapped?()
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add exercise")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}

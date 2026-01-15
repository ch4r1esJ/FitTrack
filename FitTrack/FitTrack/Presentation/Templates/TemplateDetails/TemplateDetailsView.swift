//
//  TemplateDetailsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import SwiftUI

struct TemplateDetailsView: View {
    @ObservedObject var viewModel: TemplateDetailsViewModel
    
    @State private var isShowingReorderSheet = false
    
    var onDismiss: (() -> Void)?
    var onAddExerciseTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    TextField("Template title", text: $viewModel.title)
                        .font(.title3)
                    
                    Button(action: {
                        viewModel.title = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray.opacity(0.4))
                            .font(.system(size: 20))
                    }
                    .opacity(viewModel.title.isEmpty ? 0 : 1)
                    .disabled(viewModel.title.isEmpty)
                }
                .padding()
                
                Divider()
            }
            .background(Color(uiColor: .systemBackground))
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.exercises.isEmpty {
                        emptyStateView
                            .padding(.top, 50)
                    } else {
                        ForEach($viewModel.exercises) { $exercise in
                            WorkoutExerciseCard(
                                exercise: $exercise,
                                onReorder: {
                                    isShowingReorderSheet = true
                                },
                                onDelete: {
                                    withAnimation {
                                        viewModel.deleteExercise(exercise)
                                    }
                                }
                            )
                        }
                    }
                    
                    addExerciseButton
                        .padding(.vertical)
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .navigationTitle("Create Template")
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingReorderSheet) {
            ReorderExercisesView(viewModel: viewModel)
        }
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    onDismiss?()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task {
                        let success = await viewModel.saveTemplate()
                        if success {
                            onDismiss?()
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Save")
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .cornerRadius(20)
                .disabled(viewModel.title.isEmpty || viewModel.exercises.isEmpty || viewModel.isLoading)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
        
    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(.gray.opacity(0.5))
            
            Text("Get started by adding an exercise to your template.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
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

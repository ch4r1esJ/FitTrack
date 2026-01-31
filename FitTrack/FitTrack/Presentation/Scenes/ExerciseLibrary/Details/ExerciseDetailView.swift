//
//  ExerciseDetailView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct ExerciseDetailView: View {
    @StateObject private var viewModel: ExerciseDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(exercise: Exercise) {
        _viewModel = StateObject(wrappedValue: ExerciseDetailViewModel(exercise: exercise))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                ExerciseImageView(
                    imageURL: viewModel.currentImageURL,
                    hasMultipleImages: viewModel.hasMultipleImages,
                    isAnimating: viewModel.isAnimating,
                    currentExercise: viewModel.exercise,
                    onToggleAnimation: viewModel.toggleAnimation
                )
                
                Text(viewModel.exerciseName)
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                ExerciseInfoSection(
                    level: viewModel.level,
                    category: viewModel.category,
                    equipment: viewModel.equipment,
                    force: viewModel.force,
                    mechanic: viewModel.mechanic
                )
                
                MusclesSection(
                    hasPrimaryMuscles: viewModel.hasPrimaryMuscles,
                    primaryMuscle: viewModel.primaryMuscle,
                    hasSecondaryMuscles: viewModel.hasSecondaryMuscles,
                    secondaryMuscles: viewModel.secondaryMuscles
                )
                
                if viewModel.hasInstructions {
                    InstructionsList(instructions: viewModel.instructions)
                }
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(UIColor.systemBackground))
        .onDisappear {
            viewModel.cleanup()
        }
    }
}

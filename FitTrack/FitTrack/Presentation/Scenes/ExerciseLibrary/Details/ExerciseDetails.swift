//
//  ExerciseDetails.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/22/26.
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
                imageSection
                
                Text(viewModel.exerciseName)
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                tagsSection
                
                infoCardsSection
                
                musclesSection
                
                instructionsSection
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(UIColor.systemBackground))
        .onDisappear {
            viewModel.cleanup()
        }
    }
    
    private var imageSection: some View {
        ZStack {
            AsyncImage(url: URL(string: viewModel.currentImageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "figure.strengthtraining.traditional")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Color.gray.opacity(0.1))
            
            if viewModel.hasMultipleImages {
                playButton
            }
        }
    }
    
    private var playButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: viewModel.toggleAnimation) {
                    Image(systemName: viewModel.isAnimating ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 300)
    }
    
    private var tagsSection: some View {
        HStack(spacing: 10) {
            TagView(text: viewModel.level, color: .green)
            TagView(text: viewModel.category, color: .purple)
            TagView(text: viewModel.equipment, color: .blue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
    
    private var infoCardsSection: some View {
        HStack(spacing: 20) {
            if let force = viewModel.force {
                InfoCard(icon: "arrow.right", title: "Force", value: force)
            }
            
            if let mechanic = viewModel.mechanic {
                InfoCard(icon: "gearshape.fill", title: "Mechanic", value: mechanic)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private var musclesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscles Targeted")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            if viewModel.hasPrimaryMuscles, let primaryMuscle = viewModel.primaryMuscle {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.pink)
                        Text("Primary")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.pink)
                    }
                    .padding(.horizontal, 20)
                    
                    MuscleCard(muscle: primaryMuscle, isPrimary: true)
                        .padding(.horizontal, 20)
                }
            }
            
            if viewModel.hasSecondaryMuscles {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Secondary")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.secondaryMuscles, id: \.self) { muscle in
                                SecondaryMuscleTag(muscle: muscle)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var instructionsSection: some View {
        if viewModel.hasInstructions {
            VStack(alignment: .leading, spacing: 12) {
                Text("Instructions")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                
                ForEach(Array(viewModel.instructions.enumerated()), id: \.offset) { index, instruction in
                    InstructionRow(number: index + 1, text: instruction)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.15))
            .cornerRadius(12)
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 18))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

struct MuscleCard: View {
    let muscle: String
    let isPrimary: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "waveform.path.ecg")
                .foregroundColor(.white)
            Text(muscle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.8)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
}

struct SecondaryMuscleTag: View {
    let muscle: String
    
    var body: some View {
        Text(muscle)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

struct InstructionRow: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

//
//  ActiveExerciseCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct ActiveExerciseCard: View {
    @Binding var exercise: TemplateExercise
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    
    @State private var defaultRestTime: Int = 0
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                ExerciseAvatarView(imageUrl: exercise.imageUrl)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.exerciseName)
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .lineLimit(1)
                    
                    Text(exercise.muscleGroup.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button(role: .destructive, action: {
                        onDelete()
                    }) {
                        Label("Remove Exercise", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
            }
            
            RestTimerPicker(selection: $defaultRestTime)
                .onChange(of: defaultRestTime) { oldValue, newValue in
                    viewModel.updateRestTime(for: exercise.id, to: newValue)
                }
            
            VStack(spacing: 0) {
                HStack {
                    Text("SET").frame(width: 30)
                    Spacer()
                    Text("KG").frame(width: 60)
                    Spacer()
                    Text("REPS").frame(width: 60)
                    Spacer()
                    Image(systemName: "checkmark").frame(width: 40)
                }
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
                
                ForEach($exercise.sets) { $set in
                    VStack(spacing: 0) {
                        Divider()
                        ActiveSetRowView(
                            set: $set,
                            onSetCompleted: {
                                viewModel.completeCurrentSet()
                            }
                        )
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    viewModel.addSet(to: exercise.id)
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Set")
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onAppear {
            defaultRestTime = viewModel.getDefaultRestTime(for: exercise.id)
        }
    }
}

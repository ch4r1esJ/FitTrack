//
//  ReorderExercisesView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct ReorderExercisesView: View {
    @ObservedObject var viewModel: TemplateDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(viewModel.exercises) { exercise in
                        HStack {
                            ExerciseAvatarView(imageUrl: exercise.imageUrl)
                                .frame(width: 32, height: 32)
                            
                            Text(exercise.exerciseName)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                    .onMove(perform: viewModel.moveExercise)
                    .onDelete(perform: viewModel.removeExercise)
                }
                .listStyle(.plain)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
            }
            .navigationTitle("Reorder")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, .constant(.active))
        }
    }
}

//
//  WorkoutExerciseCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/14/26.
//

import SwiftUI

struct WorkoutExerciseCard: View {
    
    @Binding var exercise: TemplateExercise
    
    @State private var defaultRestTime: Int = 0
    var onReorder: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                ExerciseAvatarView(imageUrl: exercise.imageUrl)
                
                Text(exercise.exerciseName)
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Menu {
                    Button(action: {
                        onReorder()
                    }) {
                        Label("Reorder Exercises", systemImage: "arrow.up.arrow.down")
                    }
                    
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
            
            VStack(spacing: 0) {
                HStack {
                    Text("SET").frame(width: 30)
                    Spacer()
                    Text("KG").frame(width: 60)
                    Spacer()
                    Text("REPS").frame(width: 60)
                    Spacer()
                    Color.clear.frame(width: 30)
                }
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.bottom, 8)
                
                ForEach($exercise.sets) { $set in
                    VStack(spacing: 0) {
                        Divider()
                        SetRowView(set: $set, onDelete: {
                            deleteSet(setID: set.id)
                        })
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
            
            Button(action: addSet) {
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
    }
    
    private func addSet() {
        let nextNumber = exercise.sets.count + 1
        let newSet = ExerciseSet(
            setNumber: nextNumber,
            targetWeightKg: nil,
            targetReps: 0,
            restSeconds: defaultRestTime
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            exercise.sets.append(newSet)
        }
    }
    
    private func deleteSet(setID: UUID) {
        withAnimation {
            exercise.sets.removeAll { $0.id == setID }
            
            for index in exercise.sets.indices {
                exercise.sets[index].setNumber = index + 1
            }
        }
    }
}

struct SetRowView: View {
    @Binding var set: ExerciseSet
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text("\(set.setNumber)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 30)
                .foregroundStyle(.gray)
            
            Spacer()
            
            TextField("-", value: $set.targetWeightKg, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 32)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(6)
            
            Spacer()
            
            TextField("-", value: $set.targetReps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 32)
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(6)
            
            Spacer()
            
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundStyle(.red.opacity(0.7))
            }
            .frame(width: 50)
        }
        .padding(.vertical, 8)
    }
}

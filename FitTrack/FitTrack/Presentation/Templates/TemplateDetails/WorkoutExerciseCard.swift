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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                Text(exercise.exerciseName)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.gray)
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
                .foregroundColor(.gray)
                .padding(.bottom, 8)
                
                ForEach($exercise.sets) { $set in
                    VStack(spacing: 0) {
                        Divider()
                        SetRowView(set: $set)
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
        exercise.sets.append(newSet)
    }
}

struct SetRowView: View {
    @Binding var set: ExerciseSet
    
    var body: some View {
        HStack {
            Text("\(set.setNumber)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 30)
                .foregroundColor(.gray)
            
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
                // delete logic
            }) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .frame(width: 30)
        }
        .padding(.vertical, 8)
    }
}

struct RestTimerPicker: View {
    @Binding var selection: Int
    
    var body: some View {
        Picker(selection: $selection) {
            Text("OFF").tag(0)
            ForEach(Array(stride(from: 5, through: 300, by: 5)), id: \.self) { time in
                Text("\(time)s").tag(time)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "timer")
                Text("Rest Timer: \(formatTime(selection))")
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
        .pickerStyle(.menu)
        .accentColor(.blue)
    }
    
    func formatTime(_ seconds: Int) -> String {
        return seconds == 0 ? "OFF" : (seconds < 60 ? "\(seconds)s" : "\(seconds/60) min")
    }
}

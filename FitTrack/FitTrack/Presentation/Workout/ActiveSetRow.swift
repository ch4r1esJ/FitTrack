//
//  ActiveSetRow.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/15/26.
//

import SwiftUI

struct ActiveSetRowView: View {
    @Binding var set: ExerciseSet
    var onSetCompleted: () -> Void  // Changed: removed Int parameter
    
    var body: some View {
        HStack {
            Text("\(set.setNumber)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 30)
                .foregroundStyle(set.isCompleted == true ? .green : .gray)
            
            Spacer()
            
            TextField("-", value: $set.targetWeightKg, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 32)
                .background(set.isCompleted == true ? Color.green.opacity(0.1) : Color(uiColor: .systemGray6))
                .cornerRadius(6)
            
            Spacer()
            
            TextField("-", value: $set.targetReps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 32)
                .background(set.isCompleted == true ? Color.green.opacity(0.1) : Color(uiColor: .systemGray6))
                .cornerRadius(6)
            
            Spacer()
            
            Button(action: {
                toggleCompletion()
            }) {
                ZStack {
                    if set.isCompleted == true {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green)
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(uiColor: .systemGray5))
                    }
                }
                .frame(width: 32, height: 32)
            }
            .frame(width: 40)
        }
        .padding(.vertical, 8)
        .opacity(set.isCompleted == true ? 0.8 : 1.0)
    }
    
    private func toggleCompletion() {
        withAnimation(.spring(response: 0.3)) {
            let wasCompleted = set.isCompleted ?? false
            
            // Only allow completing (not un-completing)
            if !wasCompleted {
                onSetCompleted()  // Call ViewModel method
            }
        }
    }
}

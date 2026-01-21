//
//  WorkoutCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import SwiftUI

struct Workout: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let image: String
    let tintcolor: Color
    let duration: String
    let date: Date
    let calories: String
    let isFromFitTrack: Bool
}

struct WorkoutCard: View {
    @State var workout: Workout
    var body: some View {
        HStack {
            Group {
                if workout.isFromFitTrack {
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 77, height: 77)
                } else {
                    Image(systemName: workout.image)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(workout.tintcolor)
                        .frame(width: 46, height: 46)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            
            VStack {
                HStack {
                    Text(workout.title)
                        .font(.title3)
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack {
                    Text(workout.date.formatWorkoutDate())
                    
                    Spacer()
                    
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
    }
}

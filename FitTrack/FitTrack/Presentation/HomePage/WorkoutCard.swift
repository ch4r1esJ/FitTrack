//
//  WorkoutCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import SwiftUI

struct Workout: Identifiable {
    let id: UUID = UUID() 
    let title: String
    let image: String
    let tintcolor: Color
    let duration: String
    let date: String
    let calories: String
}

struct WorkoutCard: View {
    @State var workout: Workout
    var body: some View {
        HStack {
            Image(systemName: workout.image,)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(workout.tintcolor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack {
                HStack {
                    Text(workout.title)
                        .font(.title3)
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack {
                    Text(workout.date)
                    
                    Spacer()
                    
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
    }
}

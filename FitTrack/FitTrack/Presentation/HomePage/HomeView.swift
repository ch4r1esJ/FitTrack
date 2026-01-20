//
//  HomeView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI

struct HomeView: View {
    @State var calories: Int = 123
    @State var active: Int = 12
    @State var stand: Int = 8
    
    var mockActivities = [
        Activities(id: 1, title: "Morning Run", subtitle: "Cardio", image: "figure.run", tintColor: .green, amount: "5.2 km"),
        Activities(id: 2, title: "Deep Sleep", subtitle: "Rest", image: "moon.stars.fill", tintColor: .indigo, amount: "7h 20m"),
        Activities(id: 3, title: "Water Intake", subtitle: "Hydration", image: "drop.fill", tintColor: .blue, amount: "1.5 Liters"),
        Activities(id: 4, title: "Read Book", subtitle: "Education", image: "book.fill", tintColor: .orange, amount: "45 Pages"),
        Activities(id: 5, title: "Coding Session", subtitle: "Work", image: "command", tintColor: .purple, amount: "3.5 Hours"),
        Activities(id: 6, title: "Meditation", subtitle: "Mindfulness", image: "laurel.leading", tintColor: .teal, amount: "15 mins"),
        Activities(id: 7, title: "Grocery Shopping", subtitle: "Errands", image: "cart.fill", tintColor: .pink, amount: "$84.20"),
        Activities(id: 8, title: "Gym Session", subtitle: "Strength", image: "dumbbell.fill", tintColor: .red, amount: "450 kcal"),
        Activities(id: 9, title: "Electric Charging", subtitle: "Vehicle", image: "bolt.car.fill", tintColor: .yellow, amount: "80%"),
        Activities(id: 10, title: "Piano Practice", subtitle: "Hobby", image: "music.note", tintColor: .cyan, amount: "1 Hour")    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Calories")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.red)
                            
                            Text("123 kcal")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Active")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.green )
                            
                            Text("52 mins")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stand")
                                .font(.callout)
                                .bold()
                                .foregroundColor(.green )
                            
                            Text("8 hours")
                                .bold()
                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        ProgressCircleView(progress: $calories, goal: 600, color: .red)
                        
                        ProgressCircleView(progress: $active, goal: 60, color: .green)
                            .padding(.all, 20)
                        
                        ProgressCircleView(progress: $stand, goal: 12, color: .blue)
                            .padding(.all, 40)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                
                HStack {
                    Text("Fitness Activity")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button {
                        print("show more")
                    } label: {
                        Text("Show more")
                            .padding(.all, 10)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    ForEach(mockActivities, id: \.id) { activity in
                        ActivityCard(activity: activity)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}

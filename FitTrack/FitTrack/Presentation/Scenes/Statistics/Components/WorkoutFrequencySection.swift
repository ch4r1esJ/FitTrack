//
//  WorkoutFrequencySection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Charts

struct WorkoutFrequencySection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("Workout Frequency")
                    .font(.headline)
                
                Spacer()
                
                Text("Last 8 Weeks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if viewModel.weeklyWorkoutData.isEmpty {
                EmptyChartView(message: "Not enough data yet")
            } else {
                Chart(viewModel.weeklyWorkoutData) { item in
                    BarMark(
                        x: .value("Week", item.weekLabel),
                        y: .value("Workouts", item.count)
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .cornerRadius(6)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel() {
                            if let label = value.as(String.self) {
                                Text(label)
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}

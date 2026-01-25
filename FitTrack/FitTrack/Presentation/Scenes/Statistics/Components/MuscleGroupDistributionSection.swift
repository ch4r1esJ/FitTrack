//
//  MuscleGroupDistributionSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Charts

struct MuscleGroupDistributionSection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscle Group Focus")
                .font(.headline)
            
            if viewModel.muscleGroupData.isEmpty {
                EmptyChartView(message: "No workout data available")
            } else {
                Chart(viewModel.muscleGroupData) { item in
                    SectorMark(
                        angle: .value("Count", item.count),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Muscle", item.muscleGroup))
                    .cornerRadius(5)
                }
                .frame(height: 250)
                .chartLegend(position: .bottom, alignment: .center, spacing: 12)
                .chartForegroundStyleScale { (muscle: String) in
                    muscleColors[muscle.lowercased()] ?? .gray
                }
                
                VStack(spacing: 8) {
                    ForEach(viewModel.muscleGroupData.sorted(by: { $0.count > $1.count })) { item in
                        HStack {
                            Circle()
                                .fill(getColor(for: item.muscleGroup))
                                .frame(width: 12, height: 12)
                            
                            Text(item.muscleGroup.capitalized)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(item.count) workouts")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text("\(item.percentage)%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.blue)
                                .frame(width: 50, alignment: .trailing)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
    
    private func muscleGroupColor(for muscleGroup: String) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .red, .purple, .pink, .cyan, .indigo]
        let index = abs(muscleGroup.hashValue) % colors.count
        return colors[index]
    }
    
    private var muscleColors: [String: Color] {
        [
            "legs": .blue,
            "chest": .orange,
            "back": .red,
            "shoulders": .purple,
            "core": .green,
            "arms": .cyan,
            "cardio": .yellow,
        ]
    }

    private func getColor(for muscle: String) -> Color {
        return muscleColors[muscle.lowercased()] ?? .gray
    }
}

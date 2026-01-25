//
//  VolumeOverTimeSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Charts

struct VolumeOverTimeSection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("Volume Progression")
                    .font(.headline)
                
                Spacer()
                
                Text("Last 8 Weeks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if viewModel.weeklyVolumeData.isEmpty {
                EmptyChartView(message: "Not enough data yet")
            } else {
                Chart(viewModel.weeklyVolumeData) { item in
                    LineMark(
                        x: .value("Week", item.weekLabel),
                        y: .value("Volume", item.volume)
                    )
                    .foregroundStyle(Color.orange)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Week", item.weekLabel),
                        y: .value("Volume", item.volume)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Week", item.weekLabel),
                        y: .value("Volume", item.volume)
                    )
                    .foregroundStyle(Color.orange)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                if doubleValue >= 1000 {
                                    Text("\(doubleValue / 1000, specifier: "%.1f")k")
                                } else {
                                    Text("\(doubleValue, specifier: "%.0f")")
                                }
                            }
                        }
                    }
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

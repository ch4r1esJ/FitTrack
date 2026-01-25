//
//  WorkoutDurationSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Charts

struct WorkoutDurationSection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Workout Duration")
                    .font(.headline)
                
                Spacer()
                
                Picker("Duration View", selection: $viewModel.durationViewMode) {
                    Text("Weekly").tag(DurationViewMode.weekly)
                    Text("Monthly").tag(DurationViewMode.monthly)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
            
            if viewModel.durationViewMode == .weekly {
                if viewModel.weeklyDurationByDayData.isEmpty {
                    EmptyChartView(message: "Not enough data yet")
                } else {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total time per day this week")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.bottom)
                        
                        Chart(viewModel.weeklyDurationByDayData) { item in
                            BarMark(
                                x: .value("Day", item.dayName),
                                y: .value("Duration", item.averageDuration)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.purple, Color.purple.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(6)
                        }
                        .frame(height: 220)
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisValueLabel {
                                    if let minutes = value.as(Double.self) {
                                        if minutes >= 60 {
                                            Text("\(minutes / 60, specifier: "%.1f")h")
                                        } else {
                                            Text("\(Int(minutes))m")
                                        }
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks { value in
                                AxisValueLabel() {
                                    if let day = value.as(String.self) {
                                        Text(day)
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            DurationStatPill(
                                title: "Avg Duration",
                                value: viewModel.averageWorkoutDuration,
                                icon: "clock.fill"
                            )
                            
                            DurationStatPill(
                                title: "Weekly Total",
                                value: viewModel.totalTimeThisWeek,
                                icon: "stopwatch.fill"
                            )
                        }
                        .padding(.top, 8)
                    }
                }
            } else {
                if viewModel.monthlyDurationData.isEmpty {
                    EmptyChartView(message: "Not enough data yet")
                } else {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total time per week this month")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Chart(viewModel.monthlyDurationData) { item in
                            BarMark(
                                x: .value("Week", item.weekLabel),
                                y: .value("Duration", item.totalDuration)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.purple, Color.purple.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(6)
                        }
                        .frame(height: 220)
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisValueLabel {
                                    if let minutes = value.as(Double.self) {
                                        if minutes >= 60 {
                                            Text("\(Int(minutes / 60))h")
                                        } else {
                                            Text("\(Int(minutes))m")
                                        }
                                    }
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks { value in
                                AxisValueLabel() {
                                    if let label = value.as(String.self) {
                                        Text(label)
                                            .font(.caption2)
                                    }
                                }
                            }
                        }
                        
                        HStack(spacing: 16) {
                            DurationStatPill(
                                title: "This Month",
                                value: viewModel.totalTimeThisMonth,
                                icon: "calendar"
                            )
                            
                            DurationStatPill(
                                title: "Avg Per Week",
                                value: viewModel.averageTimePerWeek,
                                icon: "clock.fill"
                            )
                        }
                        .padding(.top, 8)
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

struct DurationStatPill: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(.purple)
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
    }
}

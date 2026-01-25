//
//  SummaryCardSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI
import Combine

struct SummaryCardsSection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 12) {
                StatCard(
                    title: "This Week",
                    value: "\(viewModel.workoutsThisWeek)",
                    subtitle: "workouts",
                    icon: "figure.run",
                    color: .blue
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(viewModel.workoutsThisMonth)",
                    subtitle: "workouts",
                    icon: "calendar",
                    color: .green
                )
            }
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Volume",
                    value: viewModel.totalVolumeThisMonth,
                    subtitle: "kg this month",
                    icon: "scalemass",
                    color: .orange
                )
                
                StatCard(
                    title: "Streak",
                    value: "\(viewModel.currentStreak)",
                    subtitle: viewModel.currentStreak == 1 ? "day" : "days",
                    icon: "flame.fill",
                    color: .red
                )
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title3)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.primary)
            
            Text(subtitle)
                .font(.callout)
                .foregroundStyle(.black)
            
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}


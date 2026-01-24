//
//  WorkoutStatsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import SwiftUI
import Charts

struct WorkoutStatsView: View {
    @StateObject private var viewModel: WorkoutStatsViewModel
    
    init(viewModel: WorkoutStatsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SummaryCardsSection(viewModel: viewModel)
                    
                    WorkoutFrequencySection(viewModel: viewModel)
                    
                    VolumeOverTimeSection(viewModel: viewModel)
                    
                    WorkoutDurationSection(viewModel: viewModel)
                    
                    MuscleGroupDistributionSection(viewModel: viewModel)
                    
                    PersonalRecordsSection(viewModel: viewModel)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Statistics")
                        .font(.largeTitle)
                }
            }
            .background(Color(.systemGroupedBackground))
            .onAppear {
                viewModel.loadWorkouts()
            }
            .refreshable {
                viewModel.loadWorkouts()
            }
        }
    }
}

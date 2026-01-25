//
//  PersonalRecordsSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI

struct PersonalRecordsSection: View {
    @ObservedObject var viewModel: WorkoutStatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Personal Records")
                    .font(.headline)
                
                Spacer()
                
                if !viewModel.personalRecords.isEmpty {
                    Text("\(viewModel.personalRecords.count) PRs")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if viewModel.personalRecords.isEmpty {
                EmptyChartView(message: "Complete more workouts to see PRs")
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.personalRecords.prefix(10)) { pr in
                        PersonalRecordRow(record: pr)
                    }
                    
                    if viewModel.personalRecords.count > 10 {
                        Text("+ \(viewModel.personalRecords.count - 10) more records")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
    }
}

//
//  PersonalRecordRow.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/20/26.
//

import SwiftUI

struct PersonalRecordRow: View {
    let record: PersonalRecord
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.exerciseName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(formatDate(record.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Text("\(String(format: "%.1f", record.weight))")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("kg")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text("× \(record.reps)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

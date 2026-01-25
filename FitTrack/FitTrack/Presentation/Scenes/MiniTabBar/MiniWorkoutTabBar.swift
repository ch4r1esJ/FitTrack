//
//  MinimizedWorkoutBar.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/16/26.
//

import SwiftUI

struct MiniWorkoutTabBar: View {
    let onResume: () -> Void
    let onDiscard: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Workout in Progress")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            
            HStack(spacing: 0) {
                Button(action: onResume) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 16))
                        Text("Resume")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                
                Divider()
                    .frame(height: 30)
                
                Button(action: onDiscard) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                        Text("Discard")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.separator)),
            alignment: .top
        )
    }
}

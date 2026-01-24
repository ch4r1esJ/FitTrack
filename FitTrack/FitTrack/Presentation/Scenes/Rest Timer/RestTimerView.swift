//
//  RestTimerView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//


import SwiftUI

struct RestTimerView: View {
    @ObservedObject var restTimer: RestTimerManager
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * progress, height: 4)
                        .animation(.linear(duration: 0.3), value: progress)
                }
            }
            .frame(height: 4)
            
            Text(formatTime(restTimer.remainingSeconds))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
            
            HStack(spacing: 12) {
                Button(action: {
                    restTimer.adjustTime(by: -15)
                }) {
                    Text("-15")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    restTimer.adjustTime(by: 15)
                }) {
                    Text("+15")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    restTimer.skip()
                }) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
    
    private var progress: CGFloat {
        guard restTimer.totalSeconds > 0 else { return 0 }
        return CGFloat(restTimer.remainingSeconds) / CGFloat(restTimer.totalSeconds)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

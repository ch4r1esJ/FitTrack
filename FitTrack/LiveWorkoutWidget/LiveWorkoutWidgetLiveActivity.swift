//
//  LiveWorkoutWidgetLiveActivity.swift
//  LiveWorkoutWidget
//
//  Created by Charles Janjgava on 1/17/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveWorkoutWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WorkoutActivityAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "figure.strengthtraining.traditional")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.state.exerciseName)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Text("Set \(context.state.currentSetNumber)/\(context.state.totalSets)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.isResting {
                        VStack(spacing: 4) {
                            Text("Rest")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(context.state.restTimeRemaining)s")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    } else {
                        VStack(spacing: 4) {
                            Text(context.state.targetWeight)
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text(context.state.targetReps)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.elapsedTime)
                        .font(.title3)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.workoutName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } compactLeading: {
                Image(systemName: "figure.strengthtraining.traditional")
                    .foregroundColor(.blue)
            } compactTrailing: {
                if context.state.isResting {
                    Text("\(context.state.restTimeRemaining)s")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                } else {
                    Text(context.state.elapsedTime)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .monospacedDigit()
                }
            } minimal: {
                Image(systemName: "figure.strengthtraining.traditional")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<WorkoutActivityAttributes>
    
    var body: some View {
        if context.state.isFinished {
            finishedView
        } else if context.state.isResting {
            restTimerView
        } else {
            activeWorkoutView
        }
    }
    
    var activeWorkoutView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.workoutName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(context.state.exerciseName)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Text(context.state.elapsedTime)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Set \(context.state.currentSetNumber) of \(context.state.totalSets)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(context.state.targetWeight) × \(context.state.targetReps)")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
        }
        .padding()
    }
    
    var restTimerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.workoutName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("REST TIME")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Next: \(context.state.exerciseName) - Set \(context.state.currentSetNumber)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(context.state.elapsedTime)
                    .font(.caption)
                    .monospacedDigit()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * progressValue, height: 4)
                }
            }
            .frame(height: 4)
            
            Text(formatTime(context.state.restTimeRemaining))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    var finishedView: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Workout Complete!")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(context.state.workoutName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(context.state.elapsedTime)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .monospacedDigit()
            }
        }
        .padding()
    }
    
    private var progressValue: CGFloat {
        guard context.state.restTimeRemaining > 0 else { return 0 }
        return CGFloat(context.state.restTimeRemaining) / 60.0
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

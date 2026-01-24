//
//  WorkoutActivityAttributes.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import Foundation
import ActivityKit

struct WorkoutActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var workoutName: String
        var elapsedTime: String
        
        var exerciseName: String
        var exerciseImage: String?
        var currentSetNumber: Int
        var totalSets: Int
        var targetWeight: String
        var targetReps: String
        
        var isResting: Bool
        var restTimeRemaining: Int
        
        var isFinished: Bool
    }
    
    var workoutId: String
}

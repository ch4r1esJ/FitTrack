//
//  WorkoutIntents.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import AppIntents
import Foundation

// Complete Set Intent
struct CompleteSetIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete Set"
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Workout ID")
    var workoutId: String
    
    init(workoutId: String) {
        self.workoutId = workoutId
    }
    
    init() {
        self.workoutId = ""
    }
    
    func perform() async throws -> some IntentResult {
        
        let sharedDefaults = UserDefaults(suiteName: "group.Me.FitTrack")
        sharedDefaults?.set(true, forKey: "widget_complete_set")
        sharedDefaults?.synchronize()
        
        
        return .result()
    }
}

struct SkipRestIntent: AppIntent {
    static var title: LocalizedStringResource = "Skip Rest"
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Workout ID")
    var workoutId: String
    
    init(workoutId: String) {
        self.workoutId = workoutId
    }
    
    init() {
        self.workoutId = ""
    }
    
    func perform() async throws -> some IntentResult {
        
        let sharedDefaults = UserDefaults(suiteName: "group.Me.FitTrack")
        sharedDefaults?.set(true, forKey: "widget_skip_rest")
        sharedDefaults?.synchronize()
        
        
        return .result()
    }
}

struct AdjustRestIntent: AppIntent {
    static var title: LocalizedStringResource = "Adjust Rest Time"
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Workout ID")
    var workoutId: String
    
    @Parameter(title: "Adjustment")
    var adjustment: Int
    
    init(workoutId: String, adjustment: Int) {
        self.workoutId = workoutId
        self.adjustment = adjustment
    }
    
    init() {
        self.workoutId = ""
        self.adjustment = 0
    }
    
    func perform() async throws -> some IntentResult {
        
        let sharedDefaults = UserDefaults(suiteName: "group.Me.FitTrack")
        sharedDefaults?.set(adjustment, forKey: "widget_adjust_rest")
        sharedDefaults?.synchronize()
        
        
        return .result()
    }
}

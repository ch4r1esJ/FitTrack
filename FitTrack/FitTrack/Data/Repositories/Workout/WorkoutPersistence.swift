//
//  WorkoutPersistence.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/16/26.
//

import Foundation

struct WorkoutPersistence {
    private static let workoutKey = "minimized_workout"
    private static let elapsedTimeKey = "workout_elapsed_time"
    private static let startDateKey = "workout_start_date"
    
    private static let sharedDefaults = UserDefaults(suiteName: "group.Me.FitTrack")
    
    static func saveWorkout(_ workout: WorkoutTemplate, elapsedTime: TimeInterval, startDate: Date) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(workout) {
            sharedDefaults?.set(data, forKey: workoutKey)
            sharedDefaults?.set(elapsedTime, forKey: elapsedTimeKey)
            sharedDefaults?.set(startDate, forKey: startDateKey)
        }
    }
    
    static func loadWorkout() -> (workout: WorkoutTemplate, elapsedTime: TimeInterval, startDate: Date)? {
        guard let data = sharedDefaults?.data(forKey: workoutKey),
              let workout = try? JSONDecoder().decode(WorkoutTemplate.self, from: data),
              let startDate = sharedDefaults?.object(forKey: startDateKey) as? Date else {
            return nil
        }
        
        let elapsedTime = sharedDefaults?.double(forKey: elapsedTimeKey) ?? 0
        return (workout, elapsedTime, startDate)
    }
    
    static func clearWorkout() {
        sharedDefaults?.removeObject(forKey: workoutKey)
        sharedDefaults?.removeObject(forKey: elapsedTimeKey)
        sharedDefaults?.removeObject(forKey: startDateKey)
    }
    
    static func hasPersistedWorkout() -> Bool {
        return sharedDefaults?.data(forKey: workoutKey) != nil
    }
}

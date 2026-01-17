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
    
    static func saveWorkout(_ workout: WorkoutTemplate, elapsedTime: TimeInterval, startDate: Date) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(workout) {
            UserDefaults.standard.set(data, forKey: workoutKey)
            UserDefaults.standard.set(elapsedTime, forKey: elapsedTimeKey)
            UserDefaults.standard.set(startDate, forKey: startDateKey)
        }
    }
    
    static func loadWorkout() -> (workout: WorkoutTemplate, elapsedTime: TimeInterval, startDate: Date)? {
        guard let data = UserDefaults.standard.data(forKey: workoutKey),
              let workout = try? JSONDecoder().decode(WorkoutTemplate.self, from: data),
              let startDate = UserDefaults.standard.object(forKey: startDateKey) as? Date else {
            return nil
        }
        
        let elapsedTime = UserDefaults.standard.double(forKey: elapsedTimeKey)
        return (workout, elapsedTime, startDate)
    }
    
    static func clearWorkout() {
        UserDefaults.standard.removeObject(forKey: workoutKey)
        UserDefaults.standard.removeObject(forKey: elapsedTimeKey)
        UserDefaults.standard.removeObject(forKey: startDateKey)
    }
    
    static func hasPersistedWorkout() -> Bool {
        return UserDefaults.standard.data(forKey: workoutKey) != nil
    }
}

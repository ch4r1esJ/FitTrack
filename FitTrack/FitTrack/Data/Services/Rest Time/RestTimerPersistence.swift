//
//  RestTimerPersistence.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import Foundation

struct RestTimerPersistence {
    private static let endTimeKey = "rest_timer_end_time"
    private static let totalSecondsKey = "rest_timer_total_seconds"
    private static let isActiveKey = "rest_timer_is_active"
    
    static func saveRestTimer(endTime: Date, totalSeconds: Int) {
        UserDefaults.standard.set(endTime, forKey: endTimeKey)
        UserDefaults.standard.set(totalSeconds, forKey: totalSecondsKey)
        UserDefaults.standard.set(true, forKey: isActiveKey)
    }
    
    static func loadRestTimer() -> (endTime: Date, totalSeconds: Int)? {
        guard UserDefaults.standard.bool(forKey: isActiveKey),
              let endTime = UserDefaults.standard.object(forKey: endTimeKey) as? Date else {
            return nil
        }
        
        let totalSeconds = UserDefaults.standard.integer(forKey: totalSecondsKey)
        return (endTime, totalSeconds)
    }
    
    static func clearRestTimer() {
        UserDefaults.standard.removeObject(forKey: endTimeKey)
        UserDefaults.standard.removeObject(forKey: totalSecondsKey)
        UserDefaults.standard.removeObject(forKey: isActiveKey)
    }
}

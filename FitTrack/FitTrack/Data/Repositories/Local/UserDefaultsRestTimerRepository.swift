//
//  UserDefaultsRestTimerRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation

class UserDefaultsRestTimerRepository: RestTimerRepositoryProtocol {
    
    // MARK: - Properties
    
    private let endTimeKey = "rest_timer_end_time"
    private let totalSecondsKey = "rest_timer_total_seconds"
    private let isActiveKey = "rest_timer_is_active"
    
    private let userDefaults: UserDefaults
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Methods
    
    func saveRestTimerState(_ state: RestTimerState) throws {
        userDefaults.set(state.endTime, forKey: endTimeKey)
        userDefaults.set(state.totalSeconds, forKey: totalSecondsKey)
        userDefaults.set(true, forKey: isActiveKey)
    }
    
    func loadRestTimerState() throws -> RestTimerState? {
        guard userDefaults.bool(forKey: isActiveKey),
              let endTime = userDefaults.object(forKey: endTimeKey) as? Date else {
            return nil
        }
        
        let totalSeconds = userDefaults.integer(forKey: totalSecondsKey)
        return RestTimerState(endTime: endTime, totalSeconds: totalSeconds)
    }
    
    func clearRestTimerState() throws {
        userDefaults.removeObject(forKey: endTimeKey)
        userDefaults.removeObject(forKey: totalSecondsKey)
        userDefaults.removeObject(forKey: isActiveKey)
    }
}

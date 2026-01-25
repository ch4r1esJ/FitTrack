//
//  UserDefaultsWorkoutStateRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation

class UserDefaultsWorkoutStateRepository: WorkoutStateRepositoryProtocol {
    
    // MARK: - Properties
    
    private let workoutKey = "minimized_workout"
    private let sharedDefaults: UserDefaults?
    
    // MARK: - Init
    
    init(suiteName: String = "group.Me.FitTrack") {
        self.sharedDefaults = UserDefaults(suiteName: suiteName)
    }
    
    // MARK: - Methods
    
    func saveWorkoutState(_ state: ActiveWorkoutState) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(state)
        sharedDefaults?.set(data, forKey: workoutKey)
    }
    
    func loadWorkoutState() throws -> ActiveWorkoutState? {
        guard let data = sharedDefaults?.data(forKey: workoutKey) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(ActiveWorkoutState.self, from: data)
    }
    
    func clearWorkoutState() throws {
        sharedDefaults?.removeObject(forKey: workoutKey)
    }
    
    func hasPersistedWorkout() -> Bool {
        return sharedDefaults?.data(forKey: workoutKey) != nil
    }
}

//
//  WorkoutHistoryViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation

class WorkoutHistoryViewModel {
    
    // MARK: Properties
    
    var onWorkoutsUpdated: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    var sections: [WorkoutSection] = []
    private var allWorkouts: [CompletedWorkout] = []
    private let workoutHistoryService: WorkoutHistoryRepositoryProtocol
    
    private let userId: String
    
    // MARK: - Init
    
    init(workoutHistoryService: WorkoutHistoryRepositoryProtocol, userId: String) {
        self.workoutHistoryService = workoutHistoryService
        self.userId = userId
    }
    
    // MARK: - Methods
    
    func loadWorkouts() {
        onLoadingChanged?(true)
        
        Task {
            do {
                let fetchedWorkouts = try await workoutHistoryService.fetchUserWorkoutHistory(
                    userId: userId,
                    limit: nil
                )
                
                await MainActor.run {
                    self.allWorkouts = fetchedWorkouts
                    
                    self.groupWorkoutsByMonth()
                    
                    self.onLoadingChanged?(false)
                }
            } catch {
                await MainActor.run {
                    self.onLoadingChanged?(false)
                    self.onError?("Failed to load workouts: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteWorkout(_ workout: CompletedWorkout) {
        Task {
            do {
                try await workoutHistoryService.deleteWorkout(workoutId: workout.id)
                
                await MainActor.run {
                    self.allWorkouts.removeAll { $0.id == workout.id }
                    self.groupWorkoutsByMonth()
                }
            } catch {
                await MainActor.run {
                    self.onError?("Failed to delete workout: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func groupWorkoutsByMonth() {
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let groupedDictionary = Dictionary(grouping: allWorkouts) { (workout) -> DateComponents in
            return calendar.dateComponents([.year, .month], from: workout.endDate)
        }
        
        let sortedSections = groupedDictionary.map { (key, workouts) -> WorkoutSection in
            
            let date = calendar.date(from: key) ?? Date()
            
            let title = dateFormatter.string(from: date)
            
            let sortedWorkouts = workouts.sorted { $0.endDate > $1.endDate }
            
            return WorkoutSection(title: title, date: date, workouts: sortedWorkouts)
        }
        
        self.sections = sortedSections.sorted { $0.date > $1.date }
        
        self.onWorkoutsUpdated?()
    }
}

struct WorkoutSection {
    let title: String
    let date: Date
    var workouts: [CompletedWorkout]
}

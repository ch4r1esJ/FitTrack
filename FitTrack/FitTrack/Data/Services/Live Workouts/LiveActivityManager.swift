//
//  LiveActivityManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<WorkoutActivityAttributes>?
    
    private init() {}
    
    func startWorkoutActivity(
        workoutId: String,
        workoutName: String,
        exerciseName: String,
        exerciseImageUrl: String?,
        currentSet: Int,
        totalSets: Int,
        targetWeight: String,
        targetReps: String
    ) async {
        
        let attributes = WorkoutActivityAttributes(workoutId: workoutId)
        
        var localImagePath: String? = nil
        if let url = exerciseImageUrl {
            localImagePath = await ImageManager.shared.downloadAndSaveImageAsync(from: url)
        }
        
        let initialState = WorkoutActivityAttributes.ContentState(
            workoutName: workoutName,
            elapsedTime: "00:00",
            exerciseName: exerciseName,
            exerciseImage: localImagePath,
            currentSetNumber: currentSet,
            totalSets: totalSets,
            targetWeight: targetWeight,
            targetReps: targetReps,
            isResting: false,
            restTimeRemaining: 0,
            isFinished: false
        )
        
        do {
            let staleDate = Date().addingTimeInterval(60)
            
            currentActivity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: staleDate),
                pushType: nil
            )
        } catch {
        }
    }
    
    func updateWorkoutActivityAsync(
        elapsedTime: String? = nil,
        exerciseName: String? = nil,
        exerciseImageUrl: String? = nil,
        currentSet: Int? = nil,
        totalSets: Int? = nil,
        targetWeight: String? = nil,
        targetReps: String? = nil,
        isResting: Bool? = nil,
        restTimeRemaining: Int? = nil,
        isFinished: Bool? = nil
    ) async {
        guard let activity = currentActivity else {
            return
        }
        
        var updatedState = activity.content.state
        
        if let elapsedTime = elapsedTime { updatedState.elapsedTime = elapsedTime }
        if let exerciseName = exerciseName { updatedState.exerciseName = exerciseName }
        if let currentSet = currentSet { updatedState.currentSetNumber = currentSet }
        if let totalSets = totalSets { updatedState.totalSets = totalSets }
        if let targetWeight = targetWeight { updatedState.targetWeight = targetWeight }
        if let targetReps = targetReps { updatedState.targetReps = targetReps }
        if let isResting = isResting { updatedState.isResting = isResting }
        if let restTimeRemaining = restTimeRemaining { updatedState.restTimeRemaining = restTimeRemaining }
        if let isFinished = isFinished { updatedState.isFinished = isFinished }
        
        if let newUrl = exerciseImageUrl {
            if let localPath = ImageManager.shared.getLocalImagePath(for: newUrl) {
                updatedState.exerciseImage = localPath
            } else {
                if let newPath = await ImageManager.shared.downloadAndSaveImageAsync(from: newUrl) {
                    updatedState.exerciseImage = newPath
                } else {
                }
            }
        }
        
        let staleDate = Date().addingTimeInterval(60)
        
        await activity.update(
            ActivityContent<WorkoutActivityAttributes.ContentState>(
                state: updatedState,
                staleDate: staleDate
            )
        )
    }
    
    func updateWorkoutActivity(
        elapsedTime: String? = nil,
        exerciseName: String? = nil,
        currentSet: Int? = nil,
        totalSets: Int? = nil,
        targetWeight: String? = nil,
        targetReps: String? = nil,
        isResting: Bool? = nil,
        restTimeRemaining: Int? = nil,
        isFinished: Bool? = nil
    ) {
        guard let activity = currentActivity else { return }
        
        var updatedState = activity.content.state
        
        if let elapsedTime = elapsedTime { updatedState.elapsedTime = elapsedTime }
        if let exerciseName = exerciseName { updatedState.exerciseName = exerciseName }
        if let currentSet = currentSet { updatedState.currentSetNumber = currentSet }
        if let totalSets = totalSets { updatedState.totalSets = totalSets }
        if let targetWeight = targetWeight { updatedState.targetWeight = targetWeight }
        if let targetReps = targetReps { updatedState.targetReps = targetReps }
        if let isResting = isResting { updatedState.isResting = isResting }
        if let restTimeRemaining = restTimeRemaining { updatedState.restTimeRemaining = restTimeRemaining }
        if let isFinished = isFinished { updatedState.isFinished = isFinished }
        
        let staleDate = Date().addingTimeInterval(60)
        
        Task {
            await activity.update(
                ActivityContent<WorkoutActivityAttributes.ContentState>(
                    state: updatedState,
                    staleDate: staleDate
                )
            )
        }
    }
    
    func endWorkoutActivity() {
        guard let activity = currentActivity else { return }
        
        Task {
            await activity.end(
                ActivityContent(
                    state: activity.content.state,
                    staleDate: nil
                ),
                dismissalPolicy: .immediate
            )
            currentActivity = nil
        }
    }
}

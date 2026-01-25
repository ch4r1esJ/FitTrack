//
//  LiveActivityHelper.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation

@available(iOS 16.1, *)
class LiveActivityHelper {
    
    private let liveActivityService: LiveActivityService
    
    init(liveActivityService: LiveActivityService) {
        self.liveActivityService = liveActivityService
    }
    
    func startActivity(for template: WorkoutTemplate) async {
        let firstExercise = template.exercises.first
        let firstSet = firstExercise?.sets.first
        
        let exerciseName = firstExercise?.exerciseName ?? "No Exercise"
        let exerciseImageUrl = firstExercise?.imageUrl
        let totalSets = firstExercise?.sets.count ?? 0
        let targetWeight = formatWeight(firstSet?.targetWeightKg)
        let targetReps = formatReps(firstSet?.targetReps)
        
        await liveActivityService.startWorkoutActivity(
            workoutId: template.id,
            workoutName: template.name,
            exerciseName: exerciseName,
            exerciseImageUrl: exerciseImageUrl,
            currentSet: 1,
            totalSets: totalSets,
            targetWeight: targetWeight,
            targetReps: targetReps
        )
    }
    
    func updateElapsedTime(_ time: String) async {
        await liveActivityService.updateWorkoutActivity(elapsedTime: time)
    }
    
    func updateRestingState(isResting: Bool, remainingSeconds: Int) async {
        await liveActivityService.updateWorkoutActivity(
            isResting: isResting,
            restTimeRemaining: remainingSeconds
        )
    }
    
    func syncWithCurrentWorkout(
        _ workout: WorkoutTemplate,
        elapsedTime: String,
        isResting: Bool,
        restRemaining: Int
    ) async {
        for exercise in workout.exercises {
            for set in exercise.sets {
                if set.isCompleted != true {
                    await liveActivityService.updateWorkoutActivity(
                        elapsedTime: elapsedTime,
                        exerciseName: exercise.exerciseName,
                        exerciseImageUrl: exercise.imageUrl,
                        currentSet: set.setNumber,
                        totalSets: exercise.sets.count,
                        targetWeight: formatWeight(set.targetWeightKg),
                        targetReps: formatReps(set.targetReps),
                        isResting: isResting,
                        restTimeRemaining: restRemaining,
                        isFinished: false
                    )
                    return
                }
            }
        }
        
        await liveActivityService.updateWorkoutActivity(isFinished: true)
    }
    
    func updateToNextSet(in workout: WorkoutTemplate) async {
        for exercise in workout.exercises {
            for set in exercise.sets {
                if set.isCompleted != true {
                    await liveActivityService.updateWorkoutActivity(
                        exerciseName: exercise.exerciseName,
                        exerciseImageUrl: exercise.imageUrl,
                        currentSet: set.setNumber,
                        totalSets: exercise.sets.count,
                        targetWeight: formatWeight(set.targetWeightKg),
                        targetReps: formatReps(set.targetReps),
                        isResting: false,
                        isFinished: false
                    )
                    return
                }
            }
        }
        
        await liveActivityService.updateWorkoutActivity(isFinished: true)
    }
    
    func endActivity() {
        liveActivityService.endWorkoutActivity()
    }
    
    private func formatWeight(_ weight: Double?) -> String {
        guard let weight = weight else { return "-" }
        return String(format: "%.1f kg", weight)
    }
    
    private func formatReps(_ reps: Int?) -> String {
        guard let reps = reps else { return "-" }
        return "\(reps) reps"
    }
}

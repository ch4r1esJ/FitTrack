//
//  MockExerciseService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation

class MockExerciseService: ExerciseServiceProtocol {
    
    func fetchAllExercises() async throws -> [Exercise] {
        return [
            Exercise(
                id: "1",
                name: "Barbell Bench Press",
                primaryMuscles: ["pectorals"],
                secondaryMuscles: ["triceps", "deltoids"],
                instructions: [
                    "Lie on the bench with your eyes under the bar",
                    "Grip the bar slightly wider than shoulder width",
                    "Lower the bar to your mid-chest",
                    "Press back up to the starting position"
                ],
                images: ["bench_press.jpg"],
                level: "intermediate",
                category: "strength",
                mechanic: "compound",
                force: "push",
                muscleGroup: "Chest",
                equipment: "Barbell"
            ),
            
            Exercise(
                id: "2",
                name: "Barbell Squat",
                primaryMuscles: ["quadriceps"],
                secondaryMuscles: ["glutes", "hamstrings"],
                instructions: [
                    "Stand with feet shoulder-width apart",
                    "Rest the bar on your upper back",
                    "Squat down until your thighs are parallel to floor",
                    "Drive back up through your heels"
                ],
                images: [],
                level: "intermediate",
                category: "strength",
                mechanic: "compound",
                force: "push",
                muscleGroup: "Legs",
                equipment: "Barbell"
            ),
            
            Exercise(
                id: "3",
                name: "Pull-Up",
                primaryMuscles: ["lats"],
                secondaryMuscles: ["biceps", "forearms"],
                instructions: [
                    "Grab the bar with palms facing away",
                    "Pull your body up until chin is over the bar",
                    "Lower yourself back down with control"
                ],
                images: [],
                level: "intermediate",
                category: "strength",
                mechanic: "compound",
                force: "pull",
                muscleGroup: "Back",
                equipment: "Bodyweight"
            ),
            
            Exercise(
                id: "4",
                name: "Dumbbell Curl",
                primaryMuscles: ["biceps"],
                secondaryMuscles: ["forearms"],
                instructions: [
                    "Stand holding a dumbbell in each hand",
                    "Curl the weights up towards your shoulders",
                    "Squeeze at the top and lower slowly"
                ],
                images: [],
                level: "beginner",
                category: "strength",
                mechanic: "isolation",
                force: "pull",
                muscleGroup: "Arms",
                equipment: "Dumbbell"
            )
        ]
    }
}

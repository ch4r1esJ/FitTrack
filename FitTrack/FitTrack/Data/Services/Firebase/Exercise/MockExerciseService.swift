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
                muscleGroup: "Chest",
                equipment: "Barbell",
                difficulty: "Intermediate",
                instructions: "Lie on bench\nGrip bar\nLower to chest\nPress up",
                imageUrl: ""
            ),
            Exercise(
                id: "2",
                name: "Barbell Squat",
                muscleGroup: "Legs",
                equipment: "Barbell",
                difficulty: "Intermediate",
                instructions: "Stand with bar\nLower down\nStand up",
                imageUrl: ""
            ),
            Exercise(
                id: "3",
                name: "Deadlift",
                muscleGroup: "Back",
                equipment: "Barbell",
                difficulty: "Advanced",
                instructions: "Grip bar\nLift up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "4",
                name: "Pull-Up",
                muscleGroup: "Back",
                equipment: "Bodyweight",
                difficulty: "Intermediate",
                instructions: "Hang from bar\nPull up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "5",
                name: "Dumbbell Curl",
                muscleGroup: "Arms",
                equipment: "Dumbbell",
                difficulty: "Beginner",
                instructions: "Hold dumbbells\nCurl up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "6",
                name: "Push-Up",
                muscleGroup: "Chest",
                equipment: "Bodyweight",
                difficulty: "Beginner",
                instructions: "Hands on floor\nLower body\nPush up",
                imageUrl: ""
            ),
            Exercise(
                id: "7",
                name: "Shoulder Press",
                muscleGroup: "Shoulders",
                equipment: "Dumbbell",
                difficulty: "Intermediate",
                instructions: "Hold dumbbells\nPress up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "8",
                name: "Lat Pulldown",
                muscleGroup: "Back",
                equipment: "Machine",
                difficulty: "Beginner",
                instructions: "Sit down\nPull bar to chest\nRelease slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "9",
                name: "Leg Press",
                muscleGroup: "Legs",
                equipment: "Machine",
                difficulty: "Beginner",
                instructions: "Sit down\nPush platform\nReturn slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "10",
                name: "Tricep Pushdown",
                muscleGroup: "Arms",
                equipment: "Cable",
                difficulty: "Beginner",
                instructions: "Grip bar\nPush down\nReturn slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "11",
                name: "Bicep Barbell Curl",
                muscleGroup: "Arms",
                equipment: "Barbell",
                difficulty: "Intermediate",
                instructions: "Grip bar\nCurl up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "12",
                name: "Chest Fly",
                muscleGroup: "Chest",
                equipment: "Dumbbell",
                difficulty: "Beginner",
                instructions: "Lie on bench\nOpen arms\nBring together",
                imageUrl: ""
            ),
            Exercise(
                id: "13",
                name: "Lunges",
                muscleGroup: "Legs",
                equipment: "Bodyweight",
                difficulty: "Beginner",
                instructions: "Step forward\nLower knee\nPush back",
                imageUrl: ""
            ),
            Exercise(
                id: "14",
                name: "Plank",
                muscleGroup: "Core",
                equipment: "Bodyweight",
                difficulty: "Beginner",
                instructions: "Elbows on floor\nKeep body straight\nHold position",
                imageUrl: ""
            ),
            Exercise(
                id: "15",
                name: "Leg Curl",
                muscleGroup: "Legs",
                equipment: "Machine",
                difficulty: "Beginner",
                instructions: "Lie down\nCurl legs\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "16",
                name: "Leg Extension",
                muscleGroup: "Legs",
                equipment: "Machine",
                difficulty: "Beginner",
                instructions: "Sit down\nExtend legs\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "17",
                name: "Seated Row",
                muscleGroup: "Back",
                equipment: "Machine",
                difficulty: "Beginner",
                instructions: "Sit upright\nPull handle\nRelease slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "18",
                name: "Side Lateral Raise",
                muscleGroup: "Shoulders",
                equipment: "Dumbbell",
                difficulty: "Beginner",
                instructions: "Hold dumbbells\nRaise sides\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "19",
                name: "Front Raise",
                muscleGroup: "Shoulders",
                equipment: "Dumbbell",
                difficulty: "Beginner",
                instructions: "Hold dumbbells\nRaise front\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "20",
                name: "Crunch",
                muscleGroup: "Core",
                equipment: "Bodyweight",
                difficulty: "Beginner",
                instructions: "Lie on back\nCrunch up\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "21",
                name: "Russian Twist",
                muscleGroup: "Core",
                equipment: "Bodyweight",
                difficulty: "Intermediate",
                instructions: "Sit down\nTwist side to side\nControl movement",
                imageUrl: ""
            ),
            Exercise(
                id: "22",
                name: "Hip Thrust",
                muscleGroup: "Glutes",
                equipment: "Barbell",
                difficulty: "Intermediate",
                instructions: "Upper back on bench\nLift hips\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "23",
                name: "Calf Raise",
                muscleGroup: "Legs",
                equipment: "Bodyweight",
                difficulty: "Beginner",
                instructions: "Stand tall\nRaise heels\nLower slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "24",
                name: "Incline Dumbbell Press",
                muscleGroup: "Chest",
                equipment: "Dumbbell",
                difficulty: "Intermediate",
                instructions: "Lie on incline bench\nPress up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "25",
                name: "Hammer Curl",
                muscleGroup: "Arms",
                equipment: "Dumbbell",
                difficulty: "Beginner",
                instructions: "Hold dumbbells\nCurl up\nLower down",
                imageUrl: ""
            ),
            Exercise(
                id: "26",
                name: "Skull Crushers",
                muscleGroup: "Arms",
                equipment: "Barbell",
                difficulty: "Intermediate",
                instructions: "Lie on bench\nLower bar to forehead\nExtend arms",
                imageUrl: ""
            ),
            Exercise(
                id: "27",
                name: "Face Pull",
                muscleGroup: "Shoulders",
                equipment: "Cable",
                difficulty: "Beginner",
                instructions: "Pull rope to face\nSqueeze shoulders\nReturn slowly",
                imageUrl: ""
            ),
            Exercise(
                id: "28",
                name: "Mountain Climbers",
                muscleGroup: "Core",
                equipment: "Bodyweight",
                difficulty: "Intermediate",
                instructions: "Plank position\nDrive knees forward\nMove fast",
                imageUrl: ""
            ),
            Exercise(
                id: "29",
                name: "Burpees",
                muscleGroup: "Full Body",
                equipment: "Bodyweight",
                difficulty: "Advanced",
                instructions: "Squat down\nJump back\nJump up",
                imageUrl: ""
            ),
            Exercise(
                id: "30",
                name: "Jump Squat",
                muscleGroup: "Legs",
                equipment: "Bodyweight",
                difficulty: "Intermediate",
                instructions: "Squat down\nJump up\nLand softly",
                imageUrl: ""
            )
        ]
    }
}

//
//  MockTemplateService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/12/26.
//

import Foundation


class MockTemplateService: TemplatesServiceProtocol {
    
    func fetchAllUserTemplates(userId: String) async throws -> [WorkoutTemplate] {
        return [
            WorkoutTemplate(
                id: "1",
                name: "Leg Day",
                exercises: [
                    TemplateExercise(
                        id: "e1",
                        exerciseId: "squat",
                        exerciseName: "Barbell Squat",
                        muscleGroup: "legs",
                        equipment: "barbell",
                        sets: 4,
                        targetRepsMin: 8,
                        targetRepsMax: 12,
                        restSeconds: 180,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "2",
                name: "Push Day",
                exercises: [
                    TemplateExercise(
                        id: "e2",
                        exerciseId: "bench-press",
                        exerciseName: "Bench Press",
                        muscleGroup: "chest",
                        equipment: "barbell",
                        sets: 3,
                        targetRepsMin: 8,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "3",
                name: "Push Day",
                exercises: [
                    TemplateExercise(
                        id: "e2",
                        exerciseId: "bench-press",
                        exerciseName: "Bench Press",
                        muscleGroup: "chest",
                        equipment: "barbell",
                        sets: 3,
                        targetRepsMin: 8,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "4",
                name: "Pull Day",
                exercises: [
                    TemplateExercise(
                        id: "e3",
                        exerciseId: "deadlift",
                        exerciseName: "Deadlift",
                        muscleGroup: "back",
                        equipment: "barbell",
                        sets: 4,
                        targetRepsMin: 5,
                        targetRepsMax: 8,
                        restSeconds: 180,
                        notes: nil
                    ),
                    TemplateExercise(
                        id: "e4",
                        exerciseId: "pull-up",
                        exerciseName: "Pull-Up",
                        muscleGroup: "back",
                        equipment: "bodyweight",
                        sets: 3,
                        targetRepsMin: 6,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "5",
                name: "Shoulders",
                exercises: [
                    TemplateExercise(
                        id: "e5",
                        exerciseId: "overhead-press",
                        exerciseName: "Overhead Press",
                        muscleGroup: "shoulders",
                        equipment: "barbell",
                        sets: 4,
                        targetRepsMin: 6,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    ),
                    TemplateExercise(
                        id: "e6",
                        exerciseId: "lateral-raise",
                        exerciseName: "Dumbbell Lateral Raise",
                        muscleGroup: "shoulders",
                        equipment: "dumbbell",
                        sets: 3,
                        targetRepsMin: 12,
                        targetRepsMax: 15,
                        restSeconds: 60,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "6",
                name: "Core",
                exercises: [
                    TemplateExercise(
                        id: "e7",
                        exerciseId: "plank",
                        exerciseName: "Plank",
                        muscleGroup: "core",
                        equipment: "bodyweight",
                        sets: 3,
                        targetRepsMin: 30,
                        targetRepsMax: 60,
                        restSeconds: 60,
                        notes: "Seconds"
                    ),
                    TemplateExercise(
                        id: "e8",
                        exerciseId: "hanging-leg-raise",
                        exerciseName: "Hanging Leg Raise",
                        muscleGroup: "core",
                        equipment: "bodyweight",
                        sets: 3,
                        targetRepsMin: 10,
                        targetRepsMax: 15,
                        restSeconds: 90,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "7",
                name: "Full Body",
                exercises: [
                    TemplateExercise(
                        id: "e9",
                        exerciseId: "front-squat",
                        exerciseName: "Front Squat",
                        muscleGroup: "legs",
                        equipment: "barbell",
                        sets: 3,
                        targetRepsMin: 6,
                        targetRepsMax: 8,
                        restSeconds: 150,
                        notes: nil
                    ),
                    TemplateExercise(
                        id: "e10",
                        exerciseId: "incline-bench-press",
                        exerciseName: "Incline Bench Press",
                        muscleGroup: "chest",
                        equipment: "barbell",
                        sets: 3,
                        targetRepsMin: 8,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    ),
                    TemplateExercise(
                        id: "e11",
                        exerciseId: "barbell-row",
                        exerciseName: "Barbell Row",
                        muscleGroup: "back",
                        equipment: "barbell",
                        sets: 3,
                        targetRepsMin: 8,
                        targetRepsMax: 10,
                        restSeconds: 120,
                        notes: nil
                    )
                ],
                createdAt: Date(),
                userId: userId
            )
        ]
    }
    
    func createTemplate(_ template: WorkoutTemplate) async throws {
        print("Mock: Created template \(template.name)")
    }
    
    func updateTemplate(_ template: WorkoutTemplate) async throws {
        print("Mock: Updated template \(template.name)")
    }
    
    func deleteTemplate(id: String) async throws {
        print("Mock: Deleted template \(id)")
    }
}

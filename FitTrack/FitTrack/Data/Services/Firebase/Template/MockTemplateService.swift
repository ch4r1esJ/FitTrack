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
                name: "Chest Strength",
                exercises: [
                    TemplateExercise(
                        id: "e1",
                        exerciseId: "bench-press",
                        exerciseName: "Bench Press",
                        muscleGroup: "chest",
                        equipment: "barbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 60, targetReps: 8, restSeconds: 120),
                            ExerciseSet(setNumber: 2, targetWeightKg: 65, targetReps: 6, restSeconds: 150),
                            ExerciseSet(setNumber: 3, targetWeightKg: 70, targetReps: 4, restSeconds: 180)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "2",
                name: "Upper Push Volume",
                exercises: [
                    TemplateExercise(
                        id: "e2",
                        exerciseId: "incline-dumbbell-press",
                        exerciseName: "Incline Dumbbell Press",
                        muscleGroup: "chest",
                        equipment: "dumbbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 22, targetReps: 12, restSeconds: 90),
                            ExerciseSet(setNumber: 2, targetWeightKg: 22, targetReps: 10, restSeconds: 90)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "3",
                name: "Back Power",
                exercises: [
                    TemplateExercise(
                        id: "e3",
                        exerciseId: "deadlift",
                        exerciseName: "Deadlift",
                        muscleGroup: "back",
                        equipment: "barbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 90, targetReps: 5, restSeconds: 180),
                            ExerciseSet(setNumber: 2, targetWeightKg: 100, targetReps: 3, restSeconds: 180)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "4",
                name: "Vertical Pull",
                exercises: [
                    TemplateExercise(
                        id: "e4",
                        exerciseId: "pull-up",
                        exerciseName: "Pull-Up",
                        muscleGroup: "back",
                        equipment: "bodyweight",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 0, targetReps: 10, restSeconds: 90),
                            ExerciseSet(setNumber: 2, targetWeightKg: 0, targetReps: 8, restSeconds: 90),
                            ExerciseSet(setNumber: 3, targetWeightKg: 0, targetReps: 6, restSeconds: 120)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "5",
                name: "Leg Strength",
                exercises: [
                    TemplateExercise(
                        id: "e5",
                        exerciseId: "back-squat",
                        exerciseName: "Back Squat",
                        muscleGroup: "legs",
                        equipment: "barbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 80, targetReps: 6, restSeconds: 150),
                            ExerciseSet(setNumber: 2, targetWeightKg: 85, targetReps: 5, restSeconds: 180)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "6",
                name: "Quad Burn",
                exercises: [
                    TemplateExercise(
                        id: "e6",
                        exerciseId: "leg-extension",
                        exerciseName: "Leg Extension",
                        muscleGroup: "legs",
                        equipment: "machine",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 45, targetReps: 15, restSeconds: 60),
                            ExerciseSet(setNumber: 2, targetWeightKg: 45, targetReps: 12, restSeconds: 60),
                            ExerciseSet(setNumber: 3, targetWeightKg: 45, targetReps: 10, restSeconds: 60)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "7",
                name: "Shoulder Builder",
                exercises: [
                    TemplateExercise(
                        id: "e7",
                        exerciseId: "overhead-press",
                        exerciseName: "Overhead Press",
                        muscleGroup: "shoulders",
                        equipment: "barbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 40, targetReps: 8, restSeconds: 120),
                            ExerciseSet(setNumber: 2, targetWeightKg: 45, targetReps: 6, restSeconds: 150)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "8",
                name: "Arm Hypertrophy",
                exercises: [
                    TemplateExercise(
                        id: "e8",
                        exerciseId: "hammer-curl",
                        exerciseName: "Hammer Curl",
                        muscleGroup: "arms",
                        equipment: "dumbbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 14, targetReps: 12, restSeconds: 60),
                            ExerciseSet(setNumber: 2, targetWeightKg: 14, targetReps: 10, restSeconds: 60)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "9",
                name: "Triceps Focus",
                exercises: [
                    TemplateExercise(
                        id: "e9",
                        exerciseId: "skull-crusher",
                        exerciseName: "Skull Crushers",
                        muscleGroup: "arms",
                        equipment: "barbell",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 30, targetReps: 10, restSeconds: 75),
                            ExerciseSet(setNumber: 2, targetWeightKg: 30, targetReps: 8, restSeconds: 75),
                            ExerciseSet(setNumber: 3, targetWeightKg: 30, targetReps: 6, restSeconds: 90)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            ),
            WorkoutTemplate(
                id: "10",
                name: "Core Stability",
                exercises: [
                    TemplateExercise(
                        id: "e10",
                        exerciseId: "plank",
                        exerciseName: "Plank",
                        muscleGroup: "core",
                        equipment: "bodyweight",
                        sets: [
                            ExerciseSet(setNumber: 1, targetWeightKg: 0, targetReps: 45, restSeconds: 60),
                            ExerciseSet(setNumber: 2, targetWeightKg: 0, targetReps: 60, restSeconds: 60)
                        ]
                    )
                ],
                createdAt: Date(),
                userId: userId
            )
        ]
    }
}

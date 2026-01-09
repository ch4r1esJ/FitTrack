//
//  ExerciseConstants.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

struct ExerciseConstants {
    static let muscleGroups: [(title: String, value: String?)] = [
        ("Any Body Part", nil),
        ("Chest", "chest"),
        ("Back", "back"),
        ("Legs", "legs"),
        ("Arms", "arms"),
        ("Shoulders", "shoulders"),
        ("Core", "core"),
        ("Full Body", "fullbody"),
        ("Cardio", "cardio")
    ]
    
    static let equipmentTypes: [(title: String, value: String?)] = [
        ("Any Category", nil),
        ("Barbell", "barbell"),
        ("Dumbbell", "dumbbell"),
        ("Cable", "cable"),
        ("Bodyweight", "bodyweight"),
        ("Machine", "machine")
    ]
}

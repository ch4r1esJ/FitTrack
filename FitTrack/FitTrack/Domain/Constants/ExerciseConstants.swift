//
//  ExerciseConstants.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

struct ExerciseConstants {
    static let muscleGroups: [(String, String?)] = [
        ("Any Body Part", nil),
        ("Chest", "chest"),
        ("Back", "back"),
        ("Shoulders", "shoulders"),
        ("Arms", "arms"),
        ("Legs", "legs"),
        ("Core", "core"),
        ("Cardio", "cardio")
    ]
    
    static let equipmentTypes: [(String, String?)] = [
        ("Any Equipment", nil),
        ("Body Only", "Bodyweight"),
        ("Dumbbell", "dumbbell"),
        ("Barbell", "barbell"),
        ("Cable", "cable"),
        ("Machine", "machine"),
        ("Kettlebell", "kettlebell"),
        ("Bands", "bands")
    ]
}

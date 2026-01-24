//
//  FirebaseExerciseService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation
import FirebaseFirestore

class FirebaseExerciseService: ExerciseRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchAllExercises() async throws -> [Exercise] {
        let snapshot = try await db.collection("exercises").getDocuments()
                
        return snapshot.documents.compactMap { document -> Exercise? in
            let data = document.data()
            
            guard let name = data["name"] as? String else {
                return nil
            }
            
            let mechanic = data["mechanic"] as? String ?? "General"
            let force = data["force"] as? String ?? "General"
            
            let equipment = data["equipment"] as? String ?? "Body Only"
            
            let muscleGroup = data["bodyPartCategory"] as? String ?? "Other"
            
            let primaryMuscles = data["primaryMuscles"] as? [String] ?? []
            let secondaryMuscles = data["secondaryMuscles"] as? [String] ?? []
            let instructions = data["instructions"] as? [String] ?? []
            let images = data["images"] as? [String] ?? []
            
            let level = data["level"] as? String ?? "Beginner"
            let category = data["category"] as? String ?? "strength"

            return Exercise(
                id: document.documentID,
                name: name,
                primaryMuscles: primaryMuscles,
                secondaryMuscles: secondaryMuscles,
                instructions: instructions,
                images: images,
                level: level,
                category: category,
                
                mechanic: mechanic,
                force: force,
                muscleGroup: muscleGroup,
                equipment: equipment
            )
        }
    }
    
    func fetchUserCustomExercises(userId: String) async throws -> [Exercise] {
        let snapshot = try await db.collection("user_exercises")
            .document(userId)
            .collection("exercises")
            .getDocuments()
        
        return snapshot.documents.compactMap { document -> Exercise? in
            let data = document.data()
            
            guard let name = data["name"] as? String else {
                return nil
            }
            
            let mechanic = data["mechanic"] as? String
            let force = data["force"] as? String
            let equipment = data["equipment"] as? String ?? "Body Only"
            let muscleGroup = data["muscleGroup"] as? String ?? "Other"
            
            let primaryMuscles = data["primaryMuscles"] as? [String] ?? []
            let secondaryMuscles = data["secondaryMuscles"] as? [String] ?? []
            let instructions = data["instructions"] as? [String] ?? []
            let images = data["images"] as? [String] ?? []
            
            let level = data["level"] as? String ?? "Beginner"
            let category = data["category"] as? String ?? "custom"
            
            return Exercise(
                id: document.documentID,
                name: name,
                primaryMuscles: primaryMuscles,
                secondaryMuscles: secondaryMuscles,
                instructions: instructions,
                images: images,
                level: level,
                category: category,
                mechanic: mechanic,
                force: force,
                muscleGroup: muscleGroup,
                equipment: equipment
            )
        }
    }
    
    func createCustomExercise(_ exercise: Exercise, userId: String) async throws {
        let docRef = db.collection("user_exercises")
            .document(userId)
            .collection("exercises")
            .document(exercise.id)
        
        let data: [String: Any] = [
            "name": exercise.name,
            "primaryMuscles": exercise.primaryMuscles,
            "secondaryMuscles": exercise.secondaryMuscles,
            "instructions": exercise.instructions,
            "images": exercise.images,
            "level": exercise.level,
            "category": exercise.category,
            "muscleGroup": exercise.muscleGroup,
            "equipment": exercise.equipment,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        try await docRef.setData(data)
    }
    
    func deleteCustomExercise(exerciseId: String, userId: String) async throws {
        try await db.collection("user_exercises")
            .document(userId)
            .collection("exercises")
            .document(exerciseId)
            .delete()
    }
}

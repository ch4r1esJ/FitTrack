//
//  FirebaseExerciseService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation
import FirebaseFirestore

class FirebaseExerciseService: ExerciseServiceProtocol {
    
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
}

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
            
            // Moved 'equipment' here (so we default to "Body Only" if missing)
            let equipment = data["equipment"] as? String ?? "Body Only"
            
            // Mapping 'bodyPartCategory' -> 'muscleGroup'
            let muscleGroup = data["bodyPartCategory"] as? String ?? "Other"
            
            // Standard Arrays
            let primaryMuscles = data["primaryMuscles"] as? [String] ?? []
            let secondaryMuscles = data["secondaryMuscles"] as? [String] ?? []
            let instructions = data["instructions"] as? [String] ?? []
            let images = data["images"] as? [String] ?? []
            
            // Metadata
            let level = data["level"] as? String ?? "Beginner"
            let category = data["category"] as? String ?? "strength"

            // 3. CREATE APP MODEL
            return Exercise(
                id: document.documentID,
                name: name,
                primaryMuscles: primaryMuscles,
                secondaryMuscles: secondaryMuscles,
                instructions: instructions,
                images: images,
                level: level,
                category: category,
                
                // --- FIX START ---
                // Match the variables to their same-named properties!
                mechanic: mechanic,       // variable 'mechanic' goes to property 'mechanic'
                force: force,             // variable 'force' goes to property 'force'
                muscleGroup: muscleGroup, // variable 'muscleGroup' (Back) goes to property 'muscleGroup'
                equipment: equipment      // variable 'equipment' (Bodyweight) goes to property 'equipment'
                // --- FIX END ---
            )
        }
    }
}

//since ive changed exercise models and deleted prveous database and used otehr api, ive copied the code, so i need comprehensive code review from u to catch up what we've done

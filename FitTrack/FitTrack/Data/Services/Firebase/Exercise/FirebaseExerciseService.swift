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
        
        let exercises = snapshot.documents.compactMap { document -> Exercise? in
            let data = document.data()
            
            guard let name = data["name"] as? String,
                  let muscleGroup = data["muscleGroup"] as? String,
                  let equipment = data["equipment"] as? String,
                  let difficulty = data["difficulty"] as? String,
                  let instructions = data["instructions"] as? String else {
                return nil
            }
            
            return Exercise(
                id: document.documentID,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                difficulty: difficulty,
                instructions: instructions,
                imageUrl: data["imageUrl"] as? String ?? ""
            )
        }
        
        return exercises
    }
}

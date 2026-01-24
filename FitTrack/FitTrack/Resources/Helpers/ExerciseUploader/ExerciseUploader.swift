//
//  ExerciseUploader.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import Foundation
import FirebaseFirestore

class ExerciseUploader {
    
    private let db = Firestore.firestore()
    
    private let baseImageURL = "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/"
    
    func uploadAllExercises() {
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        
        do {
            let exercises = try JSONDecoder().decode([SourceExerciseData].self, from: data)
            
            Task {
                await processAndUpload(exercises)
            }
        } catch {
        }
    }
    
    private func processAndUpload(_ exercises: [SourceExerciseData]) async {
        let batchLimit = 400
        var batch = db.batch()
        var count = 0
        
        for exercise in exercises {
            let docRef = db.collection("exercises").document(exercise.id)
            
            let mappedData = mapToFirestoreData(exercise)
            
            batch.setData(mappedData, forDocument: docRef)
            count += 1
            
            if count >= batchLimit {
                do {
                    try await batch.commit()
                    batch = db.batch()
                    count = 0
                } catch {
                }
            }
        }
        
        if count > 0 {
            try? await batch.commit()
        }
    }
    
    private func mapToFirestoreData(_ source: SourceExerciseData) -> [String: Any] {
        
        let primaryMuscle = source.primaryMuscles.first ?? "full body"
        let appMuscleGroup = mapMuscleToCategory(primaryMuscle)
        
        let appEquipment = mapEquipment(source.equipment ?? "body only")
        
        let keywords = [
            source.name,
            appMuscleGroup,
            source.primaryMuscles.joined(separator: " "),
            appEquipment
        ].joined(separator: " ").lowercased()
        
        return [
            "id": source.id,
            "name": source.name,
            
            "primaryMuscles": source.primaryMuscles,
            "secondaryMuscles": source.secondaryMuscles,
            "instructions": source.instructions,
            "images": source.images,
            
            "level": source.level,
            "mechanic": source.mechanic ?? "compound",
            "category": source.category,
            
            "bodyPartCategory": appMuscleGroup,
            "equipment": appEquipment,
            
            "searchQuery": keywords,
            "createdAt": FieldValue.serverTimestamp()
        ]
    }
    
    private func mapMuscleToCategory(_ muscle: String) -> String {
        switch muscle.lowercased() {
        case "abdominals": return "Core"
        case "hamstrings", "quadriceps", "calves", "glutes", "adductors", "abductors": return "Legs"
        case "biceps", "triceps", "forearms": return "Arms"
        case "chest", "pectorals": return "Chest"
        case "lats", "lower back", "middle back", "traps", "neck": return "Back"
        case "shoulders", "deltoids": return "Shoulders"
        case "cardio": return "Cardio"
        default: return "Full Body"
        }
    }
    
    private func mapEquipment(_ equipment: String) -> String {
        switch equipment.lowercased() {
        case "body only": return "Bodyweight"
        case "dumbbell": return "Dumbbell"
        case "barbell": return "Barbell"
        case "cable": return "Cable"
        case "machine", "other": return "Machine"
        case "kettlebell": return "Dumbbell"
        case "e-z curl bar": return "Barbell"
        default: return "Machine"
        }
    }
}

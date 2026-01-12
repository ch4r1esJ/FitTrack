//
//  FirebaseTemplateService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/12/26.
//


import FirebaseFirestore

class FirebaseTemplateService: TemplatesServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchAllUserTemplates(userId: String) async throws -> [WorkoutTemplate] {
        let snapshot = try await db.collection("templates")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        let templates = snapshot.documents.compactMap { doc -> WorkoutTemplate? in
            let data = doc.data()
            
            guard let name = data["name"] as? String,
                  let userId = data["userId"] as? String,
                  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
                  let exercisesData = data["exercises"] as? [[String: Any]] else {
                return nil
            }
            
            let exercises = exercisesData.compactMap { exerciseData -> TemplateExercise? in
                guard let id = exerciseData["id"] as? String,
                      let exerciseId = exerciseData["exerciseId"] as? String,
                      let exerciseName = exerciseData["exerciseName"] as? String,
                      let muscleGroup = exerciseData["muscleGroup"] as? String,
                      let equipment = exerciseData["equipment"] as? String,
                      let setsData = exerciseData["sets"] as? [[String: Any]] else {
                    return nil
                }
                
                let sets = setsData.compactMap { setData -> ExerciseSet? in
                    guard let setNumber = setData["setNumber"] as? Int,
                          let targetReps = setData["targetReps"] as? Int,
                          let restSeconds = setData["restSeconds"] as? Int else {
                        return nil
                    }
                    
                    return ExerciseSet(
                        setNumber: setNumber,
                        targetWeightKg: setData["targetWeightKg"] as? Double,
                        targetReps: targetReps,
                        restSeconds: restSeconds
                    )
                }
                
                return TemplateExercise(
                    id: id,
                    exerciseId: exerciseId,
                    exerciseName: exerciseName,
                    muscleGroup: muscleGroup,
                    equipment: equipment,
                    sets: sets
                )
            }
            
            return WorkoutTemplate(
                id: doc.documentID,
                name: name,
                exercises: exercises,
                createdAt: createdAt,
                userId: userId
            )
        }
        
        return templates
    }
}

//
//  FirebaseWorkoutHistoryRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/18/26.
//

import Foundation
import FirebaseFirestore

class FirebaseWorkoutHistoryRepository: WorkoutHistoryRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    func saveCompletedWorkout(_ workout: CompletedWorkout) async throws {
        try db.collection("completedWorkouts")
            .document(workout.id)
            .setData(from: workout)
    }
    
    func fetchUserWorkoutHistory(userId: String, limit: Int? = nil) async throws -> [CompletedWorkout] {
        var query: Query = db.collection("completedWorkouts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "endDate", descending: true)
        
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        let snapshot = try await query.getDocuments()
        
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: CompletedWorkout.self)
        }
    }
    
    func fetchWorkoutById(workoutId: String) async throws -> CompletedWorkout? {
        let docRef = db.collection("completedWorkouts").document(workoutId)
        let snapshot = try await docRef.getDocument()
        return try snapshot.data(as: CompletedWorkout.self)
    }
    
    func deleteWorkout(workoutId: String) async throws {
        try await db.collection("completedWorkouts")
            .document(workoutId)
            .delete()
    }
}

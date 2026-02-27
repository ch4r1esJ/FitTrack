//
//  FirebaseTemplateRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/12/26.
//

import FirebaseFirestore

class FirebaseTemplateRepository: TemplatesRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchAllUserTemplates(userId: String) async throws -> [WorkoutTemplate] {
        let snapshot = try await db.collection("templates")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { doc in
            try doc.data(as: WorkoutTemplate.self)
        }
    }
    
    func createTemplate(_ template: WorkoutTemplate) async throws {
        try db.collection("templates")
            .document(template.id)
            .setData(from: template)
    }
    
    func updateTemplate(_ template: WorkoutTemplate) async throws {
        try db.collection("templates")
            .document(template.id)
            .setData(from: template)
    }
    
    func deleteTemplate(templateId: String) async throws {
        try await db.collection("templates")
            .document(templateId)
            .delete()
    }
}

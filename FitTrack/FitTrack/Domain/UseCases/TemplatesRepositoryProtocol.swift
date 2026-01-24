//
//  TemplatesServiceProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/12/26.
//

import Foundation

protocol TemplatesRepositoryProtocol {
    func fetchAllUserTemplates(userId: String) async throws -> [WorkoutTemplate]
    func createTemplate(_ template: WorkoutTemplate) async throws
    func updateTemplate(_ template: WorkoutTemplate) async throws
    func deleteTemplate(templateId: String) async throws
}

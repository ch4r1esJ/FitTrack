//
//  TemplatesViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/12/26.
//

import Foundation

class TemplatesViewModel {
    
    // MARK: - Properties
    
    private(set) var templates: [WorkoutTemplate] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    private let templatesService: TemplatesServiceProtocol
    
    var onError: ((String) -> Void)?
    var onTemplateUpdated: (() -> Void)?
    
    // MARK: - Init
    
    init(templatesService: TemplatesServiceProtocol) {
        self.templatesService = templatesService
    }
    
    // MARK: - Methods
    
    func fetchExercises() {
        isLoading = true
        
        Task {
            do {
                let templates = try await templatesService.fetchAllUserTemplates(userId: "3")
                await MainActor.run {
                    self.templates = templates
                    self.isLoading = false
                    self.onTemplateUpdated?()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteTemplate(withId id: String) {
        if let index = templates.firstIndex(where: { $0.id == id }) {
            templates.remove(at: index)
        }
    }
}

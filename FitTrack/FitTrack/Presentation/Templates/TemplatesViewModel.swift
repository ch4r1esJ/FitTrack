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
    private let authService: AuthServiceProtocol
    
    var onError: ((String) -> Void)?
    var onTemplateUpdated: (() -> Void)?
    
    // MARK: - Init
    
    init(templatesService: TemplatesServiceProtocol, authService: AuthServiceProtocol) {
        self.templatesService = templatesService
        self.authService = authService
    }
    
    // MARK: - Methods
    
    func fetchExercises() {
        isLoading = true
        
        guard let userId = authService.currentUser?.id else {
            self.errorMessage = "No user logged in."
            self.isLoading = false
            return
        }
        
        Task {
            do {
                let templates = try await templatesService.fetchAllUserTemplates(userId: userId )
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


//
//  TemplateDetailsViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/14/26.
//

import SwiftUI
import Combine

class TemplateDetailsViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var exercises: [TemplateExercise] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let templatesService: TemplatesServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(templatesService: TemplatesServiceProtocol, authService: AuthServiceProtocol) {
        self.templatesService = templatesService
        self.authService = authService
    }
    
    func addExercises(_ newExercises: [Exercise]) {
        for exercise in newExercises {
            if !exercises.contains(where: { $0.exerciseId == exercise.id }) {
                
                let templateExercise = TemplateExercise(
                    id: exercise.id,
                    exerciseId: exercise.id,
                    exerciseName: exercise.name,
                    imageUrl: exercise.thumbnailURL,
                    muscleGroup: exercise.muscleGroup,
                    equipment: exercise.equipment,
                    sets: [
                        ExerciseSet(setNumber: 1, targetWeightKg: nil, targetReps: 0, restSeconds: 0)
                    ]
                )
                self.exercises.append(templateExercise)
            }
        }
    }
    
    func removeExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func saveTemplate() async -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.errorMessage = "Your template needs a title"
            return false
        }
        
        guard !exercises.isEmpty else {
            self.errorMessage = "Your template needs at least one exercise"
            return false
        }
        
        guard let userId = authService.currentUser?.id else {
            self.errorMessage = "User session not found."
            return false
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        let newTemplate = WorkoutTemplate(
            id: UUID().uuidString,
            name: title,
            exercises: exercises,
            createdAt: Date(),
            userId: userId
        )
        
        do {
            try await templatesService.createTemplate(newTemplate)
            self.isLoading = false
            return true
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func deleteExercise(_ exerciseToDelete: TemplateExercise) {
        if let index = exercises.firstIndex(where: { $0.id == exerciseToDelete.id }) {
            exercises.remove(at: index)
        }
    }
    
    
}

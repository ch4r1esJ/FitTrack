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
    
    private var editingTemplateId: String?
    private var originalCreatedAt: Date?
    
    var isEditing: Bool {
        return editingTemplateId != nil
    }
    
    private let templatesService: TemplatesServiceProtocol
    private let authService: AuthServiceProtocol
    
    init(templatesService: TemplatesServiceProtocol, authService: AuthServiceProtocol) {
        self.templatesService = templatesService
        self.authService = authService
    }
    
    func configure(with template: WorkoutTemplate) {
        self.editingTemplateId = template.id
        self.title = template.name
        self.exercises = template.exercises
        self.originalCreatedAt = template.createdAt
    }
    
    func addExercises(_ newExercises: [Exercise]) {
        for exercise in newExercises {
            if !exercises.contains(where: { $0.exerciseId == exercise.id }) {
                
                let templateExercise = TemplateExercise(
                    id: UUID().uuidString,
                    exerciseId: exercise.id,
                    exerciseName: exercise.name,
                    imageUrl: exercise.thumbnailURL,
                    muscleGroup: exercise.muscleGroup,
                    equipment: exercise.equipment,
                    sets: [
                        ExerciseSet(setNumber: 1, targetWeightKg: nil, targetReps: nil, restSeconds: 0)
                    ]
                )
                self.exercises.append(templateExercise)
            }
        }
    }
    
    func deleteExercise(_ exerciseToDelete: TemplateExercise) {
        if let index = exercises.firstIndex(where: { $0.id == exerciseToDelete.id }) {
            exercises.remove(at: index)
        }
    }
    
    func removeExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
    
    func moveExercise(from source: IndexSet, to destination: Int) {
        exercises.move(fromOffsets: source, toOffset: destination)
    }
    
    func addSet(to exerciseId: String, restSeconds: Int) {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        let nextNumber = exercises[exerciseIndex].sets.count + 1
        let newSet = ExerciseSet(
            setNumber: nextNumber,
            targetWeightKg: nil,
            targetReps: nil,
            restSeconds: restSeconds
        )
        
        exercises[exerciseIndex].sets.append(newSet)
    }
    
    func deleteSet(setId: UUID, from exerciseId: String) {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        exercises[exerciseIndex].sets.removeAll { $0.id == setId }
        
        for index in exercises[exerciseIndex].sets.indices {
            exercises[exerciseIndex].sets[index].setNumber = index + 1
        }
    }
    
    func updateRestTime(for exerciseId: String, to newRestTime: Int) {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }) else {
            return
        }
        
        for index in exercises[exerciseIndex].sets.indices {
            exercises[exerciseIndex].sets[index].restSeconds = newRestTime
        }
    }
    
    func getDefaultRestTime(for exerciseId: String) -> Int {
        guard let exerciseIndex = exercises.firstIndex(where: { $0.id == exerciseId }),
              let firstSet = exercises[exerciseIndex].sets.first else {
            return 0
        }
        return firstSet.restSeconds
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
            if let existingId = editingTemplateId {
                let updatedTemplate = WorkoutTemplate(
                    id: existingId,
                    name: title,
                    exercises: exercises,
                    createdAt: originalCreatedAt ?? Date(),
                    userId: userId
                )
                try await templatesService.updateTemplate(updatedTemplate)
            } else {
                let newTemplate = WorkoutTemplate(
                    id: UUID().uuidString,
                    name: title,
                    exercises: exercises,
                    createdAt: Date(),
                    userId: userId
                )
                try await templatesService.createTemplate(newTemplate)
            }
            
            self.isLoading = false
            return true
            
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}

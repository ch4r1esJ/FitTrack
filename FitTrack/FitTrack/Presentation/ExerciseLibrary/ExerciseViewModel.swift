//
//  ExerciseViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation

class ExerciseViewModel {
    
    // MARK: - Properties
    
    private(set) var filteredExercises: [Exercise] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    private(set) var selectedMuscleGroup: String? = nil
    private(set) var selectedEquipment: String? = nil
    private var searchText: String = ""
    
    private var allExercises: [Exercise] = []
    private let exerciseService: ExerciseServiceProtocol
    
    var onExercisesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onMuscleGroupChanged: ((String?) -> Void)?
    var onEquipmentChanged: ((String?) -> Void)?
    
    // MARK: - Init
    
    init(exerciseService: ExerciseServiceProtocol) {
        self.exerciseService = exerciseService
    }
    
    // MARK: - Methods
    
    func fetchExercises() {
        isLoading = true
        
        Task {
            do {
                let exercises = try await exerciseService.fetchAllExercises()
                
                await MainActor.run {
                    self.allExercises = exercises
                    self.filteredExercises = exercises
                    self.isLoading = false
                    self.onExercisesUpdated?()
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
    
    func updateSearchText(_ text: String) {
        searchText = text
        applyFilters()
    }
    
    func selectMuscleGroup(_ value: String?) {
        selectedMuscleGroup = value
        onMuscleGroupChanged?(value)
        applyFilters()
    }
    
    func selectEquipment(_ value: String?) {
        selectedEquipment = value
        onEquipmentChanged?(value)
        applyFilters()
    }
    
    private func applyFilters() {
        var filtered = allExercises
        
        if !searchText.isEmpty {
            filtered = filtered.filter { exercise in
                exercise.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let muscle = selectedMuscleGroup {
            filtered = filtered.filter { exercise in
                return exercise.muscleGroup.localizedCaseInsensitiveContains(muscle) ||
                exercise.muscleGroup.caseInsensitiveCompare(muscle) == .orderedSame
            }
        }
        
        if let equipment = selectedEquipment {
            filtered = filtered.filter { exercise in
                return exercise.equipment.localizedCaseInsensitiveContains(equipment) ||
                exercise.equipment.caseInsensitiveCompare(equipment) == .orderedSame
            }
        }
        
        self.filteredExercises = filtered
        self.onExercisesUpdated?()
    }
}

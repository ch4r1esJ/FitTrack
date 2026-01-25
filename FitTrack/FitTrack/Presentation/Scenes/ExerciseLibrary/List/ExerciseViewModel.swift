//
//  ExerciseViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/9/26.
//

import Foundation

class ExerciseViewModel {
    
    var selectedExercises: Set<String> = []
    var filteredExercises: [Exercise] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    var selectedMuscleGroup: String? = nil
    var selectedEquipment: String? = nil
    var searchText: String = ""
    
    private var allExercises: [Exercise] = []
    private var customExercises: [Exercise] = []
    private let exerciseService: ExerciseRepositoryProtocol
    private let userId: String
    
    var onExercisesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onMuscleGroupChanged: ((String?) -> Void)?
    var onEquipmentChanged: ((String?) -> Void)?
    var onSelectionUpdated: ((Int) -> Void)?
    
    init(exerciseService: ExerciseRepositoryProtocol, userId: String) {
        self.exerciseService = exerciseService
        self.userId = userId
    }
    
    func isSelected(_ exercise: Exercise) -> Bool {
        return selectedExercises.contains(exercise.id)
    }
    
    func toggleSelection(for exercise: Exercise) {
        if selectedExercises.contains(exercise.id) {
            selectedExercises.remove(exercise.id)
        } else {
            selectedExercises.insert(exercise.id)
        }
        
        onSelectionUpdated?(selectedExercises.count)
    }
    
    func getSelectedExercises() -> [Exercise] {
        let combined = customExercises + allExercises
        return combined.filter { selectedExercises.contains($0.id) }
    }
    
    var isAddButtonVisible: Bool {
        return !selectedExercises.isEmpty
    }
    
    var addButtonTitle: String {
        let count = selectedExercises.count
        return "Add \(count) Exercise\(count == 1 ? "" : "s")"
    }
    
    func fetchExercises() {
        isLoading = true
        
        Task {
            do {
                async let regularExercises = exerciseService.fetchAllExercises()
                async let userExercises = exerciseService.fetchUserCustomExercises(userId: userId)
                
                let (regular, custom) = try await (regularExercises, userExercises)
                
                await MainActor.run {
                    self.allExercises = regular
                    self.customExercises = custom
                    
                    let combined = custom + regular
                    self.filteredExercises = combined
                    
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
        filterExercises()
    }
    
    func selectMuscleGroup(_ value: String?) {
        selectedMuscleGroup = value
        onMuscleGroupChanged?(value)
        filterExercises()
    }
    
    func selectEquipment(_ value: String?) {
        selectedEquipment = value
        onEquipmentChanged?(value)
        filterExercises()
    }
    
    private func filterExercises() {
        var filtered = customExercises + allExercises
        
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

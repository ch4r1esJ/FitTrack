//
//  CustomExerciseViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation
import Combine

class CustomExerciseViewModel: ObservableObject {
    
    @Published var exerciseName: String = ""
    @Published var selectedImage: String = "custom_exercise_1"
    @Published var primaryMuscle: String = ""
    @Published var equipment: String = ""
    @Published var level: String = "Beginner"
    @Published var secondaryMuscles: [String] = []
    @Published var instructions: [String] = [""]
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isCreated: Bool = false
    
    // MARK: - Properties
    private let exerciseService: ExerciseRepositoryProtocol
    private let userId: String
    
    let availableImages = [
        "exercise1",
        "exercise2",
        "exercise3",
        "exercise4",
        "exercise5",
        "exercise6",
        "exercise7",
        "exercise8",
        "exercise9",
        "exercise10",
        "exercise11",
        "exercise12",
        "exercise13",
        "exercise14",
        "exercise15",
        "exercise16",
        "exercise17",
        "exercise18",
        "exercise19",
        "exercise20",
        "exercise21"
    ]
    
    let muscleGroups = [
        "Chest",
        "Back",
        "Shoulders",
        "Arms",
        "Legs",
        "Core",
        "Cardio",
        "Full Body",
        "Other"
    ]
    
    let equipmentTypes = [
        "Body Only",
        "Barbell",
        "Dumbbell",
        "Machine",
        "Cable",
        "Kettlebell",
        "Bands",
        "Medicine Ball",
        "Other"
    ]
    
    let difficultyLevels = [
        "Beginner",
        "Intermediate",
        "Expert"
    ]
    
    var isFormValid: Bool {
        !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !primaryMuscle.isEmpty &&
        !equipment.isEmpty
    }
    
    var hasUnsavedChanges: Bool {
        !exerciseName.isEmpty ||
        primaryMuscle != "" ||
        equipment != "" ||
        !secondaryMuscles.isEmpty ||
        instructions.contains(where: { !$0.isEmpty })
    }
    
    // MARK: - Init
    init(exerciseService: ExerciseRepositoryProtocol, userId: String) {
        self.exerciseService = exerciseService
        self.userId = userId
    }
    
    // MARK: - Methods
    func toggleSecondaryMuscle(_ muscle: String) {
        if let index = secondaryMuscles.firstIndex(of: muscle) {
            secondaryMuscles.remove(at: index)
        } else {
            if muscle != primaryMuscle {
                secondaryMuscles.append(muscle)
            }
        }
    }
    
    func addInstruction() {
        instructions.append("")
    }
    
    func removeInstruction(at index: Int) {
        guard instructions.count > 1, index < instructions.count else { return }
        instructions.remove(at: index)
    }
    
    @MainActor
    func createExercise() async {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let validInstructions = instructions.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        let exerciseId = UUID().uuidString
        
        let customExercise = Exercise(
            id: exerciseId,
            name: exerciseName.trimmingCharacters(in: .whitespaces),
            primaryMuscles: [primaryMuscle.lowercased()],
            secondaryMuscles: secondaryMuscles.map { $0.lowercased() },
            instructions: validInstructions,
            images: [selectedImage],
            level: level,
            category: "custom",
            mechanic: nil,
            force: nil,
            muscleGroup: primaryMuscle,
            equipment: equipment
        )
        
        do {
            try await exerciseService.createCustomExercise(customExercise, userId: userId)
            isCreated = true
        } catch {
            errorMessage = "Failed to create exercise: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

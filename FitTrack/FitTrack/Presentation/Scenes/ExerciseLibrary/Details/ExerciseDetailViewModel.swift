//
//  ExerciseDetailViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/23/26.
//

import Foundation
import Combine

@MainActor
class ExerciseDetailViewModel: ObservableObject {
        
    @Published var currentImageURL: String
    @Published var isAnimating: Bool = false
        
    private let exercise: Exercise
    private var currentImageIndex: Int = 0
    private var animationTimer: Timer?
    private let animationInterval: TimeInterval = 1.0
    
    var exerciseName: String {
        exercise.name
    }
    
    var level: String {
        exercise.level
    }
    
    var category: String {
        exercise.category.capitalized
    }
    
    var equipment: String {
        exercise.equipment
    }
    
    var force: String? {
        exercise.force
    }
    
    var mechanic: String? {
        exercise.mechanic
    }
    
    var primaryMuscle: String? {
        exercise.primaryMuscles.first?.capitalized
    }
    
    var secondaryMuscles: [String] {
        exercise.secondaryMuscles.map { $0.capitalized }
    }
    
    var instructions: [String] {
        exercise.instructions
    }
    
    var hasMultipleImages: Bool {
        exercise.images.count > 1
    }
    
    var hasPrimaryMuscles: Bool {
        !exercise.primaryMuscles.isEmpty
    }
    
    var hasSecondaryMuscles: Bool {
        !exercise.secondaryMuscles.isEmpty
    }
    
    var hasInstructions: Bool {
        !exercise.instructions.isEmpty
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.currentImageURL = Self.constructImageURL(
            from: exercise.images.first ?? "",
            thumbnailURL: exercise.thumbnailURL
        )
    }
    
    func toggleAnimation() {
        if isAnimating {
            stopAnimation()
        } else {
            startAnimation()
        }
    }
    
    func cleanup() {
        stopAnimation()
    }
    
    private func startAnimation() {
        guard hasMultipleImages else { return }
        
        isAnimating = true
        animationTimer = Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { [weak self] _ in
            self?.updateImage()
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
        currentImageIndex = 0
        currentImageURL = Self.constructImageURL(
            from: exercise.images.first ?? "",
            thumbnailURL: exercise.thumbnailURL
        )
    }
    
    private func updateImage() {
        currentImageIndex = (currentImageIndex + 1) % exercise.images.count
        
        guard currentImageIndex < exercise.images.count else {
            currentImageURL = exercise.thumbnailURL
            return
        }
        
        currentImageURL = Self.constructImageURL(
            from: exercise.images[currentImageIndex],
            thumbnailURL: exercise.thumbnailURL
        )
    }
    
    private static func constructImageURL(from path: String, thumbnailURL: String) -> String {
        if path.isEmpty {
            return thumbnailURL
        }
        
        if path.hasPrefix("http") {
            return path
        }
        
        return "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/" + path
    }
}

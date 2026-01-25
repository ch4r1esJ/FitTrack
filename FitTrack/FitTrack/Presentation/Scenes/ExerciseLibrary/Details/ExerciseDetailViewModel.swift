//
//  ExerciseDetailViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/23/26.
//

import Foundation
import Combine

class ExerciseDetailViewModel: ObservableObject {
        
    @Published var currentImageURL: String
    @Published var isAnimating: Bool = false
        
    let exercise: Exercise
    private var currentImageIndex: Int = 0
    private var animationTimer: Timer?
    
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
    
    var primaryMuscle: String? {
        exercise.primaryMuscles.first?.capitalized
    }
    
    var secondaryMuscles: [String] {
        exercise.secondaryMuscles.map { $0.capitalized }
    }
    
    var instructions: [String] {
        exercise.instructions
    }
    
    var force: String? {
        exercise.force
    }
    
    var mechanic: String? {
        exercise.mechanic
    }
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.currentImageURL = ""
        self.currentImageURL = self.buildImageURL(from: exercise.images.first ?? "")
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
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateImage()
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        animationTimer?.invalidate()
        animationTimer = nil
        currentImageIndex = 0
        currentImageURL = buildImageURL(from: exercise.images.first ?? "")
    }
    
    private func updateImage() {
        currentImageIndex = (currentImageIndex + 1) % exercise.images.count
        currentImageURL = buildImageURL(from: exercise.images[currentImageIndex])
    }
    
    private func buildImageURL(from path: String) -> String {
        if path.isEmpty {
            return exercise.thumbnailURL
        }
        
        if path.hasPrefix("http") {
            return path
        }
        
        return "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/" + path
    }
}

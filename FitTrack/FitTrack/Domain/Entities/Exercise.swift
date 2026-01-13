//
//  Exercise.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    
    let primaryMuscles: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
    let images: [String]
    
    let level: String
    let category: String
    
    let mechanic: String?
    let force: String?
    
    let muscleGroup: String
    let equipment: String
    
    var thumbnailURL: String {
        guard let path = images.first else { return "" }
        if path.hasPrefix("http") { return path }
        return "https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/" + path
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case primaryMuscles, secondaryMuscles, instructions, images
        case level, category, mechanic, force, equipment
        
        case muscleGroup = "bodyPartCategory"
    }
}

//
//  SourceExerciseData.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

struct SourceExerciseData: Codable {
    let id: String
    let name: String
    let level: String
    let mechanic: String?
    let equipment: String?
    let force: String?
    let primaryMuscles: [String]
    let secondaryMuscles: [String]?
    let instructions: [String]
    let images: [String]
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, level, mechanic, equipment, force, primaryMuscles, secondaryMuscles, instructions, images, category
    }
}

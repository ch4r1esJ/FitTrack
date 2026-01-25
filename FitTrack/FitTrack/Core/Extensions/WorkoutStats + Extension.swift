//
//  WorkoutStats + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

extension WorkoutActivityStats.WorkoutType {
    var displayInfo: (title: String, image: String, color: Color) {
        switch self {
        case .running:
            return ("Running", "figure.run", .green)
        case .walking:
            return ("Walking", "figure.walk", .orange)
        case .cycling:
            return ("Cycling", "figure.outdoor.cycle", .blue)
        case .strength:
            return ("Strength", "dumbbell.fill", .red)
        case .yoga:
            return ("Yoga", "figure.yoga", .purple)
        case .hiit:
            return ("HIIT", "figure.cross.training", .yellow)
        }
    }
}

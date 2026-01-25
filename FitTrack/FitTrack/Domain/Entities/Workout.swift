//
//  Workout.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import Foundation
import SwiftUI

struct Workout: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let image: String
    let tintcolor: Color
    let duration: String
    let date: Date
    let calories: String
    let isFromFitTrack: Bool
}

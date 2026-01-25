//
//  String + Extension.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

extension String {
    func toColor() -> Color {
        switch self {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "purple": return .purple
        case "yellow": return .yellow
        case "teal": return .teal
        case "gray": return .gray
        default: return .gray
        }
    }
}

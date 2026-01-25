//
//  ExerciseInfoSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct ExerciseInfoSection: View {
    let level: String
    let category: String
    let equipment: String
    let force: String?
    let mechanic: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                TagView(text: level, color: .green)
                TagView(text: category, color: .purple)
                TagView(text: equipment, color: .blue)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            HStack(spacing: 20) {
                if let force = force {
                    InfoCard(icon: "arrow.right", title: "Force", value: force)
                }
                
                if let mechanic = mechanic {
                    InfoCard(icon: "gearshape.fill", title: "Mechanic", value: mechanic)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

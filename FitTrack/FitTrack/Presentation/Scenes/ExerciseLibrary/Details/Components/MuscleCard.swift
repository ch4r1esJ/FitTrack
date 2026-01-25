//
//  MuscleCard.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct MuscleCard: View {
    let muscle: String
    let isPrimary: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "waveform.path.ecg")
                .foregroundColor(.white)
            Text(muscle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.8)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
}

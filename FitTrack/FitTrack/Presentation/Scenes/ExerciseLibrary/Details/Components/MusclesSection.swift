//
//  MusclesSection.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct MusclesSection: View {
    let hasPrimaryMuscles: Bool
    let primaryMuscle: String?
    let hasSecondaryMuscles: Bool
    let secondaryMuscles: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscles Targeted")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 24)
            
            if hasPrimaryMuscles {
                if let primaryMuscle = primaryMuscle {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "waveform.path.ecg")
                                .foregroundColor(.pink)
                            Text("Primary")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.pink)
                        }
                        .padding(.horizontal, 20)
                        
                        MuscleCard(muscle: primaryMuscle, isPrimary: true)
                            .padding(.horizontal, 20)
                    }
                }
            }
            
            if hasSecondaryMuscles {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Secondary")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(secondaryMuscles, id: \.self) { muscle in
                                SecondaryMuscleTag(muscle: muscle)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

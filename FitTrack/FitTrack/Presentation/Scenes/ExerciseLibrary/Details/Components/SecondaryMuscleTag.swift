//
//  SecondaryMuscleTag.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct SecondaryMuscleTag: View {
    let muscle: String
    
    var body: some View {
        Text(muscle)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

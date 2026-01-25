//
//  TagView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.15))
            .cornerRadius(12)
    }
}

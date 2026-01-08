//
//  OnboardingPage.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import SwiftUI

struct OnboardingPage: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: image)
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

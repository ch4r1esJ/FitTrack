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
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.horizontal, 40)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

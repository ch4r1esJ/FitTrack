//
//  OnboardingView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var onGetStarted: () -> Void
    var onLogin: () -> Void
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                image: "dumbbell.fill",
                title: "Track Workouts",
                description: "Log every rep"
            ).tag(0)
            
            OnboardingPage(
                image: "chart.line.uptrend.xyaxis",
                title: "Monitor Progress",
                description: "See your gains"
            ).tag(1)
            
            OnboardingPage(
                image: "trophy.fill",
                title: "Achieve Goals",
                description: "Reach new PRs"
            ).tag(2)
        }
        .tabViewStyle(.page)
        .overlay(alignment: .bottom) {
            VStack(spacing: 16) {
                CustomButton(image: "emptyicon", title: "Get Started", isVisible: true) {
                    onGetStarted()
                }
                
                Button("Already have an account?") {
                    onLogin()
                }
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingView(
        onGetStarted: { print("Get Started tapped") },
        onLogin: { print("Login tapped") }
    )
}

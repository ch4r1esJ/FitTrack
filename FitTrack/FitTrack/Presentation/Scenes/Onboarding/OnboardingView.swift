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
    
    private let totalPages = 3
    private var hasSeenAllPages: Bool {
        currentPage == totalPages - 1
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                OnboardingPage(
                    image: "onboarding1",
                    title: "Track Workouts",
                    description: "Log every rep, set and workout with ease"
                ).tag(0)
                
                OnboardingPage(
                    image: "onboarding2",
                    title: "Monitor Progress",
                    description: "See your gains with detailed charts and statistics"
                ).tag(1)
                
                OnboardingPage(
                    image: "onboarding3",
                    title: "Achieve Goals",
                    description: "Reach new PRs and crush your fitness goals"
                ).tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index <= currentPage ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 16) {
                    CustomButton(
                        image: "emptyicon",
                        title: "Get Started",
                        isVisible: true,
                        isLoading: false
                    ) {
                        onGetStarted()
                    }
                    .disabled(!hasSeenAllPages)
                    .opacity(hasSeenAllPages ? 1.0 : 0.5)
                    
                    Button {
                        onLogin()
                    } label: {
                        Text("Already have an account?")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

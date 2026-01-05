//
//  SignInButtonsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct SignInButtonsView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            CustomButton(image: "emptyicon", title: "Sign In", isVisible: true) {
                viewModel.singInTapped()
            }
            .padding(.top, 5)
            
            OptionView()
            
            CustomButton(image: "google", title: "Continue with Google") {
                print("Continue with Google")
            }
            
            CustomButton(image: "apple", title: "Continue with Apple") {
                print("Continue with Google")
            }
        }
    }
}

struct OptionView: View {
    var body: some View {
        HStack(spacing: 16) {
            line
            
            Text("Or")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray.opacity(0.6))
            
            line
        }
        .padding(5)
    }
    
    private var line: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(height: 1)
    }
}

//#Preview {
//    SignInButtonsView(viewModel: LoginViewModel())
//    
//}

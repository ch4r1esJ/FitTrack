//
//  RegisterView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import SwiftUI

struct RegisterView: View {
    @FocusState private var isEmailChosen: Bool
    @FocusState private var isNameChosen: Bool
    @FocusState private var isPasswordChosen: Bool
    @FocusState private var isConfirmPasswordChosen: Bool
    @ObservedObject var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            RegisterHeaderView()
            
            VStack(spacing: 20) {
                CustomInputField(
                    title: "First Name",
                    placeholder: "Enter your First Name",
                    icon: "envelope",
                    text: $viewModel.name,
                    isFocused: $isNameChosen
                )
                
                CustomInputField(
                    title: "Email Address",
                    placeholder: "Enter your email",
                    icon: "envelope",
                    text: $viewModel.email,
                    isFocused: $isEmailChosen
                )
                
                CustomInputField(
                    title: "Password",
                    placeholder: "Enter your password",
                    icon: "lock",
                    text: $viewModel.password,
                    isSecure: true,
                    isFocused: $isPasswordChosen
                )
                
                CustomInputField(
                    title: "Confirm Password",
                    placeholder: "Confirm your password",
                    icon: "lock",
                    text: $viewModel.confirmPassword,
                    isSecure: true,
                    isFocused: $isConfirmPasswordChosen
                )
                
                CustomButton(
                    image: "emptyicon",
                    title: "Sing Up",
                    isVisible: true) {
                        viewModel.signUpTapped()
                    }
                    .padding(.top, 20)
                
                
                Spacer() // TODO: Try deleting
                
                RegisterFooter(onSignInTapped: {
                    viewModel.backToLoginTapped()
                })
            }
            .padding(20)
        }
        .ignoresSafeArea()
        .alert("Login Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown Error")
        }
        .onTapGesture {
            hideKeyboard()
            withAnimation {
                isEmailChosen = false
                isPasswordChosen = false
            }
        }
        
    }
}

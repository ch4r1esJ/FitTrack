//
//  LoginView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct LoginView: View {
    @FocusState private var isEmailChosen: Bool
    @FocusState private var isPasswordChosen: Bool
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            VStack(spacing: 20) {
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
                
                SignInButtonsView(viewModel: viewModel)
                FooterView()
                
                Spacer() // TODO: Try deleting
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

//#Preview {
//    LoginView(viewModel: LoginViewModel(loginUseCase: DefaultUseCase(repository: AuthRepository())))
//}

//
//  LoginView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var isEmailChosen: Bool
    @FocusState private var isPasswordChosen: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView()
            
            VStack(spacing: 20) {
                CustomInputField(
                    title: "Email Address",
                    placeholder: "Enter your email",
                    icon: "envelope",
                    text: $email,
                    isFocused: $isEmailChosen
                )
                
                CustomInputField(
                    title: "Password",
                    placeholder: "Enter your password",
                    icon: "lock",
                    text: $password,
                    isSecure: true,
                    isFocused: $isPasswordChosen
                )
                
                SignInButtonsView()
                FooterView()
                
                Spacer() // TODO: Try deleting
            }
            .padding(20)
        }
        .ignoresSafeArea()
        .onTapGesture {
            hideKeyboard()
            withAnimation {
                isEmailChosen = false
                isPasswordChosen = false
            }
        }
    }
}

#Preview {
    LoginView()
}

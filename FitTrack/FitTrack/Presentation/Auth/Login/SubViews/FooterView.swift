//
//  ForgotPasswordView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import SwiftUI

struct FooterView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Don't have an account?")
                
                Button {
                    viewModel.signUpTapped()
                } label: {
                    Text("Sign Up")
                        .foregroundStyle(.blue)
                        .bold()
                        .underline()
                }
            }
            Button {
                print("Forgot Password")
            } label: {
                Text("Forgot Password")
                    .foregroundStyle(.blue)
                    .bold()
                    .underline()
            }
        }
    }
}


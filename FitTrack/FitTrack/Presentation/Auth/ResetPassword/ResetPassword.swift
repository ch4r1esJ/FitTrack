//
//  ResetPassword.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: ForgotPasswordViewModel
    @FocusState private var isEmailChosen: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter your email and we'll send you a link to reset your password")
                    .font(.body)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                CustomInputField(
                    title: "Reset Password",
                    placeholder: "Enter your email",
                    icon: "envelope",
                    text: $viewModel.email,
                    isSecure: false,
                    isFocused: $isEmailChosen
                )
                .padding()
                
                CustomButton(
                    image: "emptyicon",
                    title: "Reset Password",
                    isVisible: true,
                    isLoading: viewModel.isLoading
                ) {
                    viewModel
                        .sendResetLink()
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .alert("Check Your Email", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("We've sent a password reset link to \(viewModel.email)")
            }
        }
    }
}

//
//  ForgotPasswordViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/8/26.
//


import Combine
import Foundation
import FirebaseAuth

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showSuccess = false
    
    func sendResetLink() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        guard email.contains("@"), email.contains(".") else {
            errorMessage = "Please enter a valid email"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.showSuccess = true
                }
            }
        }
    }
}

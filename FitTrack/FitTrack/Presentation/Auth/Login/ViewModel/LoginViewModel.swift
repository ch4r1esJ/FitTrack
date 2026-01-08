//
//  LoginViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoadingEmail = false
    @Published var isLoadingGoogle = false
    
    let loginFinished = PassthroughSubject<Void, Never>()
    let navigateToRegister = PassthroughSubject<Void, Never>()
    let showForgotPassword = PassthroughSubject<Void, Never>()
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func singInTapped() {
        isLoadingEmail = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await authService.signIn(email: email, password: password)
                await MainActor.run {
                    isLoadingEmail = false
                    loginFinished.send()
                }
            } catch {
                await MainActor.run {
                    isLoadingEmail = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func googleSignInTapped() {
        isLoadingGoogle = true
        
        Task {
            do {
                _ = try await authService.signInWithGoogle()
                await MainActor.run {
                    isLoadingGoogle = false
                    loginFinished.send()
                }
            } catch {
                await MainActor.run {
                    isLoadingGoogle = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signUpTapped() {
        navigateToRegister.send()
    }
    
    func forgotPasswordTapped() {
        showForgotPassword.send()
    }
}

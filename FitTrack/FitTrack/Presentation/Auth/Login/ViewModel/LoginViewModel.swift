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
    @Published var isLoading = false
    
    let loginFinished = PassthroughSubject<Void, Never>()
    let navigateToRegister = PassthroughSubject<Void, Never>()
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func singInTapped() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await authService.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    loginFinished.send()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func googleSignInTapped() {
        isLoading = true
        
        Task {
            do {
                _ = try await authService.signInWithGoogle()
                await MainActor.run {
                    isLoading = false
                    loginFinished.send()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signUpTapped() {
        navigateToRegister.send()
    }
}

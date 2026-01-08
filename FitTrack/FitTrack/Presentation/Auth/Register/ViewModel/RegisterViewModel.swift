//
//  RegisterViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import Combine
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var name = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    let registerFinished = PassthroughSubject<Void, Never>()
    let navigateToLogin = PassthroughSubject<Void, Never>()
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func signUpTapped() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                guard password == confirmPassword else {
                    await MainActor.run {
                        isLoading = false
                        errorMessage = "Passwords don't match"
                    }
                    return
                }
                
                _ = try await authService.signUp(
                    email: email,
                    password: password,
                    name: name
                )
                
                await MainActor.run {
                    isLoading = false
                    registerFinished.send()
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func backToLoginTapped() {
        navigateToLogin.send()
    }
}

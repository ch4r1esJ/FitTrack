//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AuthDIContainer {
    lazy var authService: AuthServiceProtocol = {
        FirebaseAuthService()
        
    }()
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(authService: authService)
    }
}

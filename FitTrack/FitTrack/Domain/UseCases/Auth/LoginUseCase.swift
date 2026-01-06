//
//  LoginUseCase.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Combine

protocol LoginUseCase {
    func execute(email: String, password: String) -> AnyPublisher<User, Error>
    func executeGoogle() -> AnyPublisher<User, Error>
}

class DefaultUseCase: LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) -> AnyPublisher<User, Error> {
        guard email.contains("@") && email.contains(".") else {
            return Fail(error: AuthError.invalidEmailFormat)
                .eraseToAnyPublisher()
        }
        
        guard password.count >= 6 else {
            return Fail(error: AuthError.passwordTooShort)
                .eraseToAnyPublisher()
        }
        
        return repository.signIn(password: password, email: email)
    }
    
    func executeGoogle() -> AnyPublisher<User, Error> {
        return repository.signInWithGoogle()
    }
}

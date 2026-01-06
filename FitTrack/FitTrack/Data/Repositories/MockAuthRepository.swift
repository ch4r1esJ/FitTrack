//
//  MockAuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Combine
import Foundation

class MockAuthRepository: AuthRepository {
    func signInWithGoogle() -> AnyPublisher<User, any Error> {
        let fakeUser = User(id: "01", email: "Gmail", name: "Test User")
        
        return Just(fakeUser)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        let fakeUser = User(id: "01", email: email, name: "Test User")
        
        return Just(fakeUser)
            .setFailureType(to: Error.self)
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func signOut() throws {
        print("Sign out")
    }
}

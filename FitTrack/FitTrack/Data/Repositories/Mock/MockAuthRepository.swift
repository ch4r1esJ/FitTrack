//
//  MockAuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation
import Combine

final class MockAuthService: AuthServiceProtocol {
    var currentUser: User? = nil
    
    var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    func signIn(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000) 
        let user = User(
            id: "mock123",
            email: email,
            name: "Test User",
        )
        currentUser = user
        return user
    }
    
    func signInWithGoogle() async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(
            id: "mockGoogle",
            email: "test@gmail.com",
            name: "Google User",
        )
        currentUser = user
        return user
    }
    
    func signUp(email: String, password: String, name: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(
            id: "mockNew",
            email: email,
            name: name,
        )
        currentUser = user
        return user
    }
    
    func signOut() throws {
        currentUser = nil
    }
    
    func sendPasswordReset(email: String) async throws {
        print("Reset PAssword")
    }
}

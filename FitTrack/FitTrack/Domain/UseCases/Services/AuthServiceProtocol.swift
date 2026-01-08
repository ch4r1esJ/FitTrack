//
//  AuthRepositoryProtocol.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signOut() throws
    func signUp(email: String, password: String, name: String) async throws -> User
    func sendPasswordReset(email: String) async throws
    
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
}

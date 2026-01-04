//
//  AuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

protocol AuthRepository {
    func signIn(password: String, email: String) async throws -> User
    func singUp(password: String, email: String, name: String) async throws -> User
    func singOut() throws
}

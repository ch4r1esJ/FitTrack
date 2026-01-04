//
//  AuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

protocol AuthRepository {
    func signIn(password: String, email: String) async throws -> String
}

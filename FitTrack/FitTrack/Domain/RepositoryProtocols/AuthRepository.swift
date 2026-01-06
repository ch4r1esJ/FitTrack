//
//  AuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation
import Combine

protocol AuthRepository {
    func signIn(password: String, email: String) -> AnyPublisher<User, Error>
    func signInWithGoogle() -> AnyPublisher<User, Error>
//    func signUp(email: String, password: String, name: String) -> AnyPublisher<User, Error>
//    func singOut() throws
}

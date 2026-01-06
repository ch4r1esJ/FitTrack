//
//  FirebaseAuthRepository.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn

class FirebaseAuthRepository: AuthRepository {
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                self?.handleAuthResult(result, error, promise: promise)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                promise(.failure(AuthError.unknownError("Cannot find root view controller")))
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    promise(.failure(AuthError.unknownError("Failed to get Google credentials")))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                
                Auth.auth().signIn(with: credential) { result, error in
                    self?.handleAuthResult(result, error, promise: promise)
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    // Helpers
    
    private func mapFirebaseUser(_ firebaseUser: FirebaseAuth.User) -> User {
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            name: firebaseUser.displayName ?? "User"
        )
    }
    
    private func handleAuthResult(_ result: AuthDataResult?, _ error: Error?, promise: (Result<User, Error>) -> Void) {
        if let error = error as NSError? {
            let authError = mapFirebaseError(error)
            promise(.failure(authError))
            return
        }
        
        if let firebaseUser = result?.user {
            let domainUser = mapFirebaseUser(firebaseUser)
            promise(.success(domainUser))
        }
    }
    
    private func mapFirebaseError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknownError(error.localizedDescription)
        }
        
        switch errorCode {
        case .userNotFound:
            return .userNotFound
        case .wrongPassword:
            return .wrongPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .invalidEmail:
            return .invalidEmailFormat
        case .networkError:
            return .networkError
        case .weakPassword:
            return .passwordTooShort
        default:
            return .unknownError(error.localizedDescription)
        }
    }
}


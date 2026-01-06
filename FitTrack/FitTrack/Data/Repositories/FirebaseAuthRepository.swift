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
    
    func signIn(password: String, email: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                self?.handleAuthResult(result, error, promise: promise)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func signInWithGoogle() -> AnyPublisher<User, Error> {
        return Future<User, Error> { [weak self] promise in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)
                
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
        if let error = error {
            promise(.failure(error))
            return
        }
        
        if let firebaseUser = result?.user {
            let domainUser = mapFirebaseUser(firebaseUser)
            promise(.success(domainUser))
        }
    }
}


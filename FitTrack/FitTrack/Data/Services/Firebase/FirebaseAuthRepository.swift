//
//  FirebaseAuthService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn

class FirebaseAuthService: AuthServiceProtocol {
    var currentUser: User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return mapFirebaseUser(firebaseUser)
    }
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signIn(email: String, password: String) async throws -> User {
        guard email.contains("@"), email.contains(".") else {
            throw AuthError.invalidEmailFormat
        }
        
        guard password.count >= 6 else {
            throw AuthError.passwordTooShort
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return mapFirebaseUser(result.user)
        } catch {
            throw mapFirebaseError(error as NSError)
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signInWithGoogle() async throws -> User {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                throw AuthError.unknownError("Cannot find root view controller")
            }
            
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                
                guard let idToken = result.user.idToken?.tokenString else {
                    throw AuthError.unknownError("Failed to get Google credentials")
                }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: result.user.accessToken.tokenString
                )
                
                let authResult = try await Auth.auth().signIn(with: credential)
                return mapFirebaseUser(authResult.user)
                
            } catch {
                throw mapFirebaseError(error as NSError)
            }
        }
    
    func signUp(email: String, password: String, name: String) async throws -> User {
            guard !name.isEmpty else {
                throw AuthError.emptyName
            }
            
            guard email.contains("@"), email.contains(".") else {
                throw AuthError.invalidEmailFormat
            }
            
            guard password.count >= 6 else {
                throw AuthError.passwordTooShort
            }
            
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = name
                try await changeRequest.commitChanges()
                
                return mapFirebaseUser(result.user)
                
            } catch {
                throw mapFirebaseError(error as NSError)
            }
        }
        
    private func mapFirebaseUser(_ firebaseUser: FirebaseAuth.User) -> User {
        return User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            name: firebaseUser.displayName ?? "User"
        )
    }
    
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
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


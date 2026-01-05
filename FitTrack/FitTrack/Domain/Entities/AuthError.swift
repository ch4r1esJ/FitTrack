//
//  AuthError.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/5/26.
//

import Foundation

enum AuthError: LocalizedError {
    case emptyEmail
    case invalidEmailFormat
    case emptyPassword
    case passwordTooShort
    
    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case networkError
    case unknownError(String)
    
    var errorDescription: String? {
            switch self {
            case .emptyEmail:
                return "Please enter your email"
            case .invalidEmailFormat:
                return "Please enter a valid email address (must contain @ and .)"
            case .emptyPassword:
                return "Please enter your password"
            case .passwordTooShort:
                return "Password must be at least 6 characters"
                
            case .userNotFound:
                return "No account found with this email"
            case .wrongPassword:
                return "Incorrect password. Please try again"
            case .emailAlreadyInUse:
                return "This email is already registered"
            case .networkError:
                return "Network error. Please check your connection"
            case .unknownError(let message):
                return message
            }
        }
}

//
//  AuthError.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/5/26.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail: return "Please enter a valid email address"
        case .weakPassword: return "Password must be at least 6 characters"
        case .networkError: return "Network error. Please try again"
        }
    }
}

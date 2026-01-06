//
//  LogoutUseCase.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import Foundation

protocol LogoutUseCase {
    func execute() throws
}

class DefaultLogoutUseCase: LogoutUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() throws {
        try repository.signOut()
    }
}

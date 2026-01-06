//
//  ProfileViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//


import Combine
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var errorMessage: String?
    
    let logoutFinished = PassthroughSubject<Void, Never>()
    
    private let logoutUseCase: LogoutUseCase
    
    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }
    
    func logoutTapped() {
        do {
            try logoutUseCase.execute()
            logoutFinished.send()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
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
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func logoutTapped() {
        do {
            try authService.signOut()
            logoutFinished.send()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

//
//  LoginViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    let loginFinished = PassthroughSubject<Void, Never>()
    
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
        
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func singInTapped() {
        isLoading = true
        errorMessage = nil
        
        loginUseCase.execute(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.loginFinished.send()
            }
            .store(in: &cancellables)
    }
    
    func googleSignInTapped() {
        isLoading = true
        loginUseCase.executeGoogle()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.loginFinished.send()
            }
            .store(in: &cancellables)
    }
}

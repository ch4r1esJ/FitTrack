//
//  AuthCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import UIKit
import SwiftUI
import Combine
import FirebaseAuth

class AuthCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    weak var parentCoordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>() 
    private let loginUseCase: LoginUseCase
    
    init(navigationController: UINavigationController, loginUseCase: LoginUseCase) {
        self.navigationController = navigationController
        self.loginUseCase = loginUseCase
    }
    
    func start() {
        if isFirstLaunch() {
            showOnboarding()
        } else {
            showLogin()
        }
    }
    
    private func showOnboarding() {
        let onboardingView = OnboardingView(
            onGetStarted: { [weak self] in
                self?.showRegister()
            },
            onLogin: { [weak self] in
                self?.showLogin()
            }
        )
        
        let hostingController = UIHostingController(rootView: onboardingView)
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    private func showLogin() {
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        viewModel.loginFinished
            .sink { [weak self] _ in
                self?.didFinishAuth()
            }
            .store(in: &cancellables)
        
        let loginView = LoginView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: loginView)
        
        navigationController.setViewControllers([hostingController], animated: true)
    }
    
    private func didFinishAuth() {
            markOnboardingAsSeen()
            
            parentCoordinator?.showHome()
        }
    
    private func showRegister() {
        print("Register screen")
    }
    
    private func isFirstLaunch() -> Bool {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        return !hasSeenOnboarding
    }
    
    private func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}

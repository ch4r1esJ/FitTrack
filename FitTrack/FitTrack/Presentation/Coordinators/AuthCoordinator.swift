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
    
    private let diContainer: AuthDIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, diContainer: AuthDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
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
        let viewModel = diContainer.makeLoginViewModel()
        
        viewModel.loginFinished
            .sink { [weak self] _ in
                self?.didFinishAuth()
            }
            .store(in: &cancellables)
        
        viewModel.navigateToRegister
            .sink { [weak self] _ in
                self?.showRegister()
            }
            .store(in: &cancellables)
        
        let loginView = LoginView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: loginView)
        
        navigationController.setViewControllers([hostingController], animated: true)
    }
    
    private func showRegister() {
        let viewModel = diContainer.makeRegisterViewModel()
        
        viewModel.registerFinished
            .sink { [weak self] _ in
                self?.didFinishAuth()
            }
            .store(in: &cancellables)
        
        viewModel.navigateToLogin
            .sink { [weak self] _ in
                self?.showLogin()
            }
            .store(in: &cancellables)
        
        let registerView = RegisterView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: registerView)
        
        navigationController.setViewControllers([hostingController], animated: true)
    }
    
    private func didFinishAuth() {
        markOnboardingAsSeen()
        parentCoordinator?.showHome()
    }
    
    private func isFirstLaunch() -> Bool {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        return !hasSeenOnboarding
    }
    
    private func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}

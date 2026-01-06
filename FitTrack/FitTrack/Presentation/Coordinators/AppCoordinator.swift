//
//  AppCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import UIKit
import SwiftUI
import Combine
import FirebaseAuth

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private var cancellables = Set<AnyCancellable>() // TODO: Syntax
    private let loginUseCase: LoginUseCase
    
    init(navigationController: UINavigationController, loginUseCase: LoginUseCase) {
        self.navigationController = navigationController
        self.loginUseCase = loginUseCase
    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            showHome()
        } else {
            showAuth()
        }
    }
    
    private func showAuth() {
        let viewModel = LoginViewModel(loginUseCase: loginUseCase)
        
        viewModel.loginFinished
            .sink { [weak self] _ in // TODO: weakself
                self?.showHome()
            }
            .store(in: &cancellables)
        
        let loginView = LoginView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: loginView)
        
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    func showHome() {
        print("Home")
        
        let tabBarController = UITabBarController()
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

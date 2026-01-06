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
    
    private var cancellables = Set<AnyCancellable>()
    private let loginUseCase: LoginUseCase
    
    private var authCoordinator: AuthCoordinator?
    
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
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            loginUseCase: loginUseCase
        )
        
        authCoordinator.parentCoordinator = self
        self.authCoordinator = authCoordinator
        
        authCoordinator.start()
    }
    
    func showHome() {
        self.authCoordinator = nil
        let tabBarController = UITabBarController()
        
        
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

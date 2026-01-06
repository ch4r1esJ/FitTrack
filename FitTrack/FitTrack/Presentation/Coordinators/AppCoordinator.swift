//
//  AppCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import UIKit
import Combine
import FirebaseAuth

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private var cancellables = Set<AnyCancellable>()
    private let loginUseCase: LoginUseCase
    private let logoutUseCase: LogoutUseCase
    
    private var authCoordinator: AuthCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(navigationController: UINavigationController,
         loginUseCase: LoginUseCase,
         logoutUseCase: LogoutUseCase) {
        self.navigationController = navigationController
        self.loginUseCase = loginUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            showHome()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        tabBarCoordinator = nil
        
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            loginUseCase: loginUseCase
        )
        
        authCoordinator.parentCoordinator = self
        self.authCoordinator = authCoordinator
        
        authCoordinator.start()
    }
    
    func showHome() {
        authCoordinator = nil
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            logoutUseCase: logoutUseCase
        )
        
        tabBarCoordinator.parentCoordinator = self
        self.tabBarCoordinator = tabBarCoordinator
        
        tabBarCoordinator.start()
    }
}

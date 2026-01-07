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
    
    private let authDIContainer: AuthDIContainer
    private var authCoordinator: AuthCoordinator?
    
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(navigationController: UINavigationController, authDIContainer: AuthDIContainer) {
        self.navigationController = navigationController
        self.authDIContainer = authDIContainer
    }
    
    func start() {
        if Auth.auth().currentUser != nil {
            showHome()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController,
            diContainer: authDIContainer 
        )
        
        authCoordinator.parentCoordinator = self
        self.authCoordinator = authCoordinator
        
        authCoordinator.start()
    }
    
    func showHome() {
        authCoordinator = nil
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            authService: authDIContainer.authService
        )
        
        tabBarCoordinator.parentCoordinator = self
        self.tabBarCoordinator = tabBarCoordinator
        
        tabBarCoordinator.start()
    }
    
    func logout() {
        try? Auth.auth().signOut()
        tabBarCoordinator = nil
        showAuth()
    }
}

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
    private let diContainer: AppDIContainer
    private var authCoordinator: AuthCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
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
            diContainer: diContainer
        )
        
        authCoordinator.parentCoordinator = self
        self.authCoordinator = authCoordinator
        
        authCoordinator.start()
    }
    
    func showHome() {
        authCoordinator = nil
        
        let tabBarCoordinator = TabBarCoordinator(
            navigationController: navigationController,
            authRepository: diContainer.authRepository,
            diContainer: diContainer
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

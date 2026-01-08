//
//  TabBarCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import UIKit
import SwiftUI
import Combine

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var tabBarController: MainTabBarController!
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol) { 
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start() {
        tabBarController = MainTabBarController()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let profileViewModel = ProfileViewModel(authService: authService)
        profileViewModel.logoutFinished
            .sink { [weak self] _ in
                self?.didLogout()
            }
            .store(in: &cancellables)
        
        let profileView = ProfileView(viewModel: profileViewModel)
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        tabBarController.viewControllers = [homeVC, profileVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func didLogout() {
        parentCoordinator?.showAuth()
    }
}

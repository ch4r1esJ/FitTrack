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
    
    private let logoutUseCase: LogoutUseCase
    private var cancellables = Set<AnyCancellable>()
    private var tabBarController: MainTabBarController!
    
    init(navigationController: UINavigationController, logoutUseCase: LogoutUseCase) {
        self.navigationController = navigationController
        self.logoutUseCase = logoutUseCase
    }
    
    func start() {
        tabBarController = MainTabBarController()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        let profileViewModel = ProfileViewModel(logoutUseCase: logoutUseCase)
        profileViewModel.logoutFinished
            .sink { [weak self] _ in
                self?.didLogout()
            }
            .store(in: &cancellables)
        
        let profileVC = UIHostingController(rootView: ProfileView(viewModel: profileViewModel))
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.circle"),
            tag: 1
        )
        
        tabBarController.viewControllers = [homeVC, profileVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func didLogout() {
        parentCoordinator?.showAuth()
    }
}

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
    private let diContainer: AppDIContainer
    private var tabBarController: MainTabBarController!
    
    private var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.authService = authService
        self.diContainer = diContainer
    }
    
    func start() {
        tabBarController = MainTabBarController()
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let templatesNav = UINavigationController()
        templatesNav.tabBarItem = UITabBarItem(
            title: "Templates",
            image: UIImage(systemName: "list.bullet.clipboard"),
            selectedImage: UIImage(systemName: "list.bullet.clipboard.fill")
        )
        
        let templatesCoordinator = TemplatesCoordinator(
            navigationController: templatesNav,
            diContainer: diContainer
        )
    
        templatesCoordinator.start()
        childCoordinators.append(templatesCoordinator)
        
        let exerciseVC = diContainer.makeExerciseViewController()
        let exerciseNav = UINavigationController(rootViewController: exerciseVC)
        exerciseVC.tabBarItem = UITabBarItem(
            title: "Workouts",
            image: UIImage(systemName: "figure.strengthtraining.traditional"),
            selectedImage: UIImage(systemName: "figure.strengthtraining.traditional")
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
        
        tabBarController.viewControllers = [homeVC, templatesNav, exerciseNav, profileVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func didLogout() {
        parentCoordinator?.showAuth()
    }
}

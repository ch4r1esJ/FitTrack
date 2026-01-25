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
    
    private let authRepository: AuthRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let diContainer: AppDIContainer
    private var tabBarController: MainTabBarController!
    
    private var childCoordinators = [Coordinator]()
    
    init(
        navigationController: UINavigationController,
        authRepository: AuthRepositoryProtocol,
        diContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.authRepository = authRepository
        self.diContainer = diContainer
    }
    
    func start() {
        tabBarController = MainTabBarController(
            workoutStateObserver: diContainer.workoutStateObserver
        )
        
        tabBarController.onResumeWorkout = { [weak self] in
            self?.resumeWorkout()
        }
        
        let historyNav = UINavigationController()
        historyNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.fill")
        )
        
        let historyCoordinator = HistoryCoordinator(
            navigationController: historyNav,
            diContainer: diContainer
        )
        
        historyCoordinator.start()
        childCoordinators.append(historyCoordinator)
        
        let statsVC = diContainer.makeWorkoutStatsView()
        let statsNav = UIHostingController(rootView: statsVC)
        statsNav.tabBarItem = UITabBarItem(
            title: "Stats",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
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
        
        let profileViewModel = ProfileViewModel(authService: authRepository)
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
        
        let homeViewModel = diContainer.makeHomeViewModel()
        let homeView = HomeView(viewModel: homeViewModel)
        let homeVc = UIHostingController(rootView: homeView)
        homeVc.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        tabBarController.viewControllers = [homeVc, templatesNav, historyNav, statsNav, profileVC]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    private func resumeWorkout() {
        guard let templatesCoordinator = childCoordinators.first(where: { $0 is TemplatesCoordinator }) as? TemplatesCoordinator else {
            return
        }
        
        templatesCoordinator.resumeMinimizedWorkout()
    }
    
    private func didLogout() {
        parentCoordinator?.showAuth()
    }
}

//
//  MainTabBarController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .blue
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true
    }
}

//import UIKit
//import SwiftUI
//
//class MainTabBarController: UITabBarController {
//    private var homeVC: HomeViewController!
//    private var profile: ProfileView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabs()
//        setupTabBarAppearance()
//    }
//    
//    private func setupTabs() {
//        homeVC = HomeViewController()
//        let profileVC = UIHostingController(rootView: ProfileView())
//        
//        homeVC.tabBarItem = UITabBarItem(
//            title: "Home",
//            image: UIImage(systemName: "house"),
//            tag: 0
//        )
//        
//        profileVC.tabBarItem = UITabBarItem(
//            title: "Profile",
//            image: UIImage(systemName: "list.bullet.circle"),
//            tag: 1
//        )
//        
//        viewControllers = [homeVC, profileVC]
//    }
//    
//    private func setupTabBarAppearance() {
//        tabBar.tintColor = .blue
//        tabBar.backgroundColor = .clear
//        tabBar.isTranslucent = true
//    }
//}

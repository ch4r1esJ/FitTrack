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

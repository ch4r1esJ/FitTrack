//
//  MainTabBarController.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/6/26.
//

import UIKit
import SwiftUI
import Combine

class MainTabBarController: UITabBarController {
    
    private var miniBarHostingController: UIHostingController<MiniWorkoutTabBar>?
    private var cancellables = Set<AnyCancellable>()
    private let workoutStateObserver: WorkoutStateObserver
    
    var onResumeWorkout: (() -> Void)?
    
    init(workoutStateObserver: WorkoutStateObserver) {
        self.workoutStateObserver = workoutStateObserver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupWorkoutObserver()
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .blue
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true
    }
    
    private func setupWorkoutObserver() {
        workoutStateObserver.$hasActiveWorkout
            .sink { [weak self] hasActiveWorkout in
                if hasActiveWorkout {
                    self?.showMinimizedBar()
                } else {
                    self?.hideMinimizedBar()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showMinimizedBar() {
        guard miniBarHostingController == nil else { return }
        
        let miniBar = MiniWorkoutTabBar(
            onResume: { [weak self] in
                self?.onResumeWorkout?()
            },
            onDiscard: { [weak self] in
                self?.showDiscardAlert()
            }
        )
        
        let hostingController = UIHostingController(rootView: miniBar)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hostingController.view)
        addChild(hostingController)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        hostingController.didMove(toParent: self)
        miniBarHostingController = hostingController
    }
    
    private func hideMinimizedBar() {
        miniBarHostingController?.willMove(toParent: nil)
        miniBarHostingController?.view.removeFromSuperview()
        miniBarHostingController?.removeFromParent()
        miniBarHostingController = nil
    }
    
    private func showDiscardAlert() {
        let alert = UIAlertController(
            title: "Discard Workout?",
            message: "Are you sure you want to discard this workout? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.workoutStateObserver.markWorkoutDiscarded()
        })
        
        present(alert, animated: true)
    }
}

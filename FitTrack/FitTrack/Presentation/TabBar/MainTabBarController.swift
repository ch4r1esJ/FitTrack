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
    
    private var minimizedBarHostingController: UIHostingController<MinimizedWorkoutBarContainer>?
    private var cancellables = Set<AnyCancellable>()
    private let workoutManager = WorkoutManager.shared
    
    var onResumeWorkout: (() -> Void)?
    
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
        // Observe workout state
        workoutManager.statePublisher
            .sink { [weak self] state in
                if state == .minimized {
                    self?.showMinimizedBar()
                } else {
                    self?.hideMinimizedBar()
                }
            }
            .store(in: &cancellables)
    }
    
    private func showMinimizedBar() {
        guard minimizedBarHostingController == nil else { return }
        
        let containerView = MinimizedWorkoutBarContainer(
            onResume: { [weak self] in
                self?.onResumeWorkout?()
            },
            onDiscard: { [weak self] in
                self?.showDiscardAlert()
            }
        )
        
        let hostingController = UIHostingController(rootView: containerView)
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
        self.minimizedBarHostingController = hostingController
    }
    
    private func hideMinimizedBar() {
        minimizedBarHostingController?.willMove(toParent: nil)
        minimizedBarHostingController?.view.removeFromSuperview()
        minimizedBarHostingController?.removeFromParent()
        minimizedBarHostingController = nil
    }
    
    private func showDiscardAlert() {
        let alert = UIAlertController(
            title: "Discard Workout?",
            message: "Are you sure you want to discard this workout? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
            self?.workoutManager.discardWorkout()
        })
        
        present(alert, animated: true)
    }
}

struct MinimizedWorkoutBarContainer: View {
    let onResume: () -> Void
    let onDiscard: () -> Void
    
    var body: some View {
        MinimizedWorkoutBar(
            onResume: onResume,
            onDiscard: onDiscard
        )
    }
}

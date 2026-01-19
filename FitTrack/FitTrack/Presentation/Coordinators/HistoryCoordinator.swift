//
//  HistoryCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit
import SwiftUI

class HistoryCoordinator: Coordinator {
    // MARK: - Properties
    var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    // MARK: - Init
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        // Create the VC
        let historyVC = diContainer.makeWorkoutHistoryViewController()
        
        // Setup the navigation closure
        historyVC.didSelectWorkout = { [weak self] workout in
            self?.showWorkoutDetail(workout)
        }
        
        // Push it onto the stack
        navigationController.pushViewController(historyVC, animated: false)
    }
    
    private func showWorkoutDetail(_ workout: CompletedWorkout) {
        // Since WorkoutDetailViewController is simple and doesn't have a ViewModel factory yet,
        // we can instantiate it directly or add a factory method to DIContainer if you prefer.
        let detailVC = WorkoutDetailViewController(workout: workout)
        
        detailVC.onTapBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(detailVC, animated: true)
    }
}

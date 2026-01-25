//
//  HistoryCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import UIKit
import SwiftUI

class HistoryCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let historyVC = diContainer.makeWorkoutHistoryViewController()
        
        historyVC.didSelectWorkout = { [weak self] workout in
            self?.showWorkoutDetail(workout)
        }
        
        navigationController.pushViewController(historyVC, animated: false)
    }
    
    private func showWorkoutDetail(_ workout: CompletedWorkout) {
        let detailVC = WorkoutDetailViewController(workout: workout)
        
        detailVC.onTapBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(detailVC, animated: true)
    }
}

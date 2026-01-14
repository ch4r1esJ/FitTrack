//
//  TemplatesCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import UIKit
import SwiftUI

class TemplatesCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let diContainer: AppDIContainer
    
    private weak var createTemplateNavController: UINavigationController?
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let templatesVC = diContainer.makeTemplatesViewController()
        
        templatesVC.didTapCreateTemplate = { [weak self] in
            self?.showTemplateDetails()
        }
        
        navigationController.pushViewController(templatesVC, animated: false)
    }
    
    private func showTemplateDetails() {
        var detailView = TemplateDetailsView()
        
        detailView.onAddExerciseTapped = { [weak self] in
            self?.showExerciseSelection()
        }
        
        detailView.onDismiss = { [weak self] in
            self?.createTemplateNavController?.dismiss(animated: true)
            self?.createTemplateNavController = nil
        }
        
        let hostingController = UIHostingController(rootView: detailView)
        
        let navWrapper = UINavigationController(rootViewController: hostingController)
        navWrapper.modalPresentationStyle = .fullScreen
        
        self.createTemplateNavController = navWrapper
        
        navigationController.present(navWrapper, animated: true)
    }
    
    private func showExerciseSelection() {
        let exerciseVC = diContainer.makeExerciseViewController()
        
        exerciseVC.onAddExerciseTapped = { [weak self] in
            self?.createTemplateNavController?.popViewController(animated: true)
        }
        
        createTemplateNavController?.setNavigationBarHidden(false, animated: false)
        createTemplateNavController?.pushViewController(exerciseVC, animated: true)
    }
}

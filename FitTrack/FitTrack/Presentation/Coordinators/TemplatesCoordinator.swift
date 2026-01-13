//
//  TemplatesCoordinator.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/13/26.
//

import UIKit
import SwiftUI
import Combine

class TemplatesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let diContainer: AppDIContainer
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let templatesVC = diContainer.makeTemplatesViewController()
        
        templatesVC.didSelectTemplate = { [weak self] template in
            self?.showTemplateDetails(for: template)
        }
        
        navigationController.pushViewController(templatesVC, animated: false)
    }
    
    private func showTemplateDetails(for template: WorkoutTemplate) {
        let detailView = TemplateDetailsView(template: template)
        
        let hostingController = UIHostingController(rootView: detailView)
        
        hostingController.title = template.name
        hostingController.hidesBottomBarWhenPushed = true
        
        navigationController.pushViewController(hostingController, animated: true)
    }
}

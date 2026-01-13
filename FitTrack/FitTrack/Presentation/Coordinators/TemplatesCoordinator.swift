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
        
        templatesVC.didTapCreateTemplate = { [weak self] in
            self?.showTemplateDetails()
        }
        
        navigationController.pushViewController(templatesVC, animated: false)
    }
    
    private func showTemplateDetails() {
        let detailView = TemplateDetailsView()
        
        let hostingController = UIHostingController(rootView: detailView)
        
        hostingController.modalPresentationStyle = .fullScreen
        
        navigationController.present(hostingController, animated: true)
    }
}

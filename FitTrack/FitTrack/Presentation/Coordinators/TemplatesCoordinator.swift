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
    
    private var templateNavController: UINavigationController?
    private var workoutNavController: UINavigationController?
    
    init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let templatesVC = diContainer.makeTemplatesViewController()
        setupCalls(for: templatesVC)
        navigationController.pushViewController(templatesVC, animated: false)
    }
    
    private func setupCalls(for templatesVC: TemplatesViewController) {
        templatesVC.didTapCreateTemplate = { [weak self] in
            self?.showTemplateDetails(template: nil)
        }
        
        templatesVC.didSelectTemplate = { [weak self] template in
            self?.showTemplateDetails(template: template)
        }
        
        templatesVC.didTapStartWorkout = { [weak self] template in
            self?.startWorkout(with: template)
        }
    }
    
    private func showTemplateDetails(template: WorkoutTemplate?) {
        let viewModel = diContainer.makeTemplateDetailsViewModel()
        
        if let template = template {
            viewModel.configure(with: template)
        }
        
        var detailView = TemplateDetailsView(viewModel: viewModel)
        
        detailView.onAddExerciseTapped = { [weak self] in
            self?.showExerciseSelection { exercises in
                viewModel.addExercises(exercises)
            }
        }
        
        detailView.onDismiss = { [weak self] in
            self?.dismissTemplateDetails()
        }
        
        let hostingController = UIHostingController(rootView: detailView)
        let navController = UINavigationController(rootViewController: hostingController)
        navController.modalPresentationStyle = .fullScreen
        
        self.templateNavController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func dismissTemplateDetails() {
        templateNavController?.dismiss(animated: true)
        templateNavController = nil
    }
    
    private func showExerciseSelection(completion: @escaping ([Exercise]) -> Void) {
        let exerciseVC = makeExerciseViewController()
        
        exerciseVC.onAddExerciseTapped = { [weak self] in
            self?.templateNavController?.popViewController(animated: true)
            self?.templateNavController?.setNavigationBarHidden(false, animated: true)
        }
        
        exerciseVC.didSelectExercises = { [weak self] exercises in
            completion(exercises)
            self?.templateNavController?.popViewController(animated: true)
            self?.templateNavController?.setNavigationBarHidden(false, animated: true)
        }
        
        exerciseVC.onShowExerciseDetails = { [weak self] exercise in
            self?.showExerciseDetails(exercise)
        }
        
        templateNavController?.pushViewController(exerciseVC, animated: true)
    }
    
    private func startWorkout(with template: WorkoutTemplate) {
        if diContainer.workoutStateRepository.hasPersistedWorkout() {
            showDiscardWorkoutAlert(for: template)
            return
        }
        
        let viewModel = diContainer.makeActiveWorkoutViewModel()
        viewModel.startWorkout(from: template)
        
        setupWorkoutCalls(for: viewModel)
        
        var activeWorkoutView = ActiveWorkoutView(viewModel: viewModel)
        
        activeWorkoutView.onAddExerciseTapped = { [weak self] in
            self?.showExerciseSelectionForWorkout(viewModel: viewModel)
        }
        
        let hostingController = UIHostingController(rootView: activeWorkoutView)
        let navController = UINavigationController(rootViewController: hostingController)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        
        self.workoutNavController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func showDiscardWorkoutAlert(for template: WorkoutTemplate) {
        let alert = UIAlertController(
            title: "Active Workout",
            message: "You have an active workout. Do you want to discard it and start a new one?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Discard & Start New", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            try? self.diContainer.workoutStateRepository.clearWorkoutState()
            
            self.diContainer.workoutStateObserver.checkWorkoutState()
            
            if #available(iOS 16.1, *) {
                Task {
                    await self.diContainer.liveActivityService?.endAllActivitiesAndWait()
                    
                    await MainActor.run {
                        self.startWorkoutAfterDiscard(with: template)
                    }
                }
            } else {
                self.startWorkoutAfterDiscard(with: template)
            }
        })
        
        navigationController.present(alert, animated: true)
    }
    
    private func startWorkoutAfterDiscard(with template: WorkoutTemplate) {
        let viewModel = diContainer.makeActiveWorkoutViewModel()
        viewModel.startWorkout(from: template)
        
        setupWorkoutCalls(for: viewModel)
        
        var activeWorkoutView = ActiveWorkoutView(viewModel: viewModel)
        
        activeWorkoutView.onAddExerciseTapped = { [weak self] in
            self?.showExerciseSelectionForWorkout(viewModel: viewModel)
        }
        
        let hostingController = UIHostingController(rootView: activeWorkoutView)
        let navController = UINavigationController(rootViewController: hostingController)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        
        self.workoutNavController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func setupWorkoutCalls(for viewModel: ActiveWorkoutViewModel) {
        viewModel.onFinish = { [weak self] in
            self?.dismissWorkout()
        }
        
        viewModel.onMinimize = { [weak self] in
            self?.workoutNavController?.dismiss(animated: true)
        }
    }
    
    private func showExerciseSelectionForWorkout(viewModel: ActiveWorkoutViewModel) {
        let exerciseVC = makeExerciseViewController()
        
        exerciseVC.onAddExerciseTapped = { [weak self] in
            self?.workoutNavController?.popViewController(animated: true)
        }
        
        exerciseVC.didSelectExercises = { [weak self] exercises in
            viewModel.addExercises(exercises)
            self?.workoutNavController?.popViewController(animated: true)
        }
        
        exerciseVC.onShowExerciseDetails = { [weak self] exercise in
            self?.showExerciseDetails(exercise)
        }
        
        workoutNavController?.pushViewController(exerciseVC, animated: true)
    }
    
    func resumeMinimizedWorkout() {
        let viewModel = diContainer.makeActiveWorkoutViewModel()
        
        setupWorkoutCalls(for: viewModel)
        
        var activeWorkoutView = ActiveWorkoutView(viewModel: viewModel)
        
        activeWorkoutView.onAddExerciseTapped = { [weak self] in
            self?.showExerciseSelectionForWorkout(viewModel: viewModel)
        }
        
        let hostingController = UIHostingController(rootView: activeWorkoutView)
        let navController = UINavigationController(rootViewController: hostingController)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        
        self.workoutNavController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func dismissWorkout() {
        workoutNavController?.dismiss(animated: true)
        workoutNavController = nil
    }
    
    private func showExerciseDetails(_ exercise: Exercise) {
        let detailView = ExerciseDetailView(exercise: exercise)
        let hostingController = UIHostingController(rootView: detailView)
        hostingController.modalPresentationStyle = .pageSheet
        
        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        
        if let workoutNav = workoutNavController, workoutNav.view.window != nil {
            workoutNav.present(hostingController, animated: true)
        } else if let templateNav = templateNavController, templateNav.view.window != nil {
            templateNav.present(hostingController, animated: true)
        }
    }
    
    private func makeExerciseViewController() -> ExercisesViewController {
        let viewModel = diContainer.makeExerciseViewModel()
        let exerciseVC = ExercisesViewController(viewModel: viewModel, diContainer: diContainer)
        
        exerciseVC.onCreateExerciseTapped = { [weak self] in
            self?.showCustomExerciseCreation()
        }
        
        return exerciseVC
    }
    
    private func showCustomExerciseCreation() {
        let viewModel = diContainer.makeCustomExerciseViewModel()
        
        var customExerciseView = CustomExerciseView(viewModel: viewModel)
        
        customExerciseView.onDismiss = { [weak self] in
            self?.dismissCustomExerciseCreation()
        }
        
        let hostingController = UIHostingController(rootView: customExerciseView)
        hostingController.modalPresentationStyle = .fullScreen
        
        if let workoutNav = workoutNavController, workoutNav.view.window != nil {
            workoutNav.present(hostingController, animated: true)
        } else if let templateNav = templateNavController, templateNav.view.window != nil {
            templateNav.present(hostingController, animated: true)
        }
    }
    
    private func dismissCustomExerciseCreation() {
        if let workoutNav = workoutNavController {
            workoutNav.dismiss(animated: true)
        } else if let templateNav = templateNavController {
            templateNav.dismiss(animated: true)
        }
    }
}

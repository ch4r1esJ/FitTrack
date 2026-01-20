//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AppDIContainer {
    
    // Auth
    lazy var authService: AuthServiceProtocol = {
        FirebaseAuthService()
        
    }()
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(authService: authService)
    }
    
    // Exercise Librart
    
    lazy var exerciseService: ExerciseServiceProtocol = {
        return FirebaseExerciseService()
    }()
    
    func makeExerciseViewModel() -> ExerciseViewModel {
        return ExerciseViewModel(exerciseService: exerciseService)
    }
    
    func makeExerciseViewController() -> ExerciesViewController {
        let viewModel = makeExerciseViewModel()
        return ExerciesViewController(viewModel: viewModel)
    }
    
    // Templates
    
    lazy var templatesService: TemplatesServiceProtocol = {
        return FirebaseTemplateService()
    }()
    
    func makeTemplatesViewModel() -> TemplatesViewModel {
        return TemplatesViewModel(templatesService: templatesService, authService: authService)
    }
    
    func makeTemplatesViewController() -> TemplatesViewController {
        let viewModel = makeTemplatesViewModel()
        return TemplatesViewController(viewModel: viewModel)
    }
    
    // Template Details
    
    func makeTemplateDetailsViewModel() -> TemplateDetailsViewModel {
        return TemplateDetailsViewModel(
            templatesService: templatesService,
            authService: authService
        )
    }
    
    // Workout Session
    
    private lazy var workoutManager: WorkoutSessionProtocol = {
        return WorkoutManager()
    }()
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        return ActiveWorkoutViewModel(workoutService: WorkoutManager.shared)
    }
    
    // Workout History
    
    lazy var workoutHistoryService: WorkoutHistoryServiceProtocol = {
        return FirebaseWorkoutHistoryService()
    }()
    
    func makeWorkoutHistoryViewModel() -> WorkoutHistoryViewModel {
        let currentUserId = authService.currentUser?.id ?? "No User"
        
        return WorkoutHistoryViewModel(workoutHistoryService: FirebaseWorkoutHistoryService(), userId: currentUserId)
    } 
    
    func makeWorkoutHistoryViewController() -> WorkoutHistoryViewController {
        let viewModel = makeWorkoutHistoryViewModel()
        return WorkoutHistoryViewController(viewModel: viewModel)
    }
    
    func makeWorkoutStatsViewModel() -> WorkoutStatsViewModel {
        let currentUserId = authService.currentUser?.id ?? "No User"
        
        return WorkoutStatsViewModel(workoutHistoryService: FirebaseWorkoutHistoryService(), userId: currentUserId)
    }
    
    func makeWorkoutStatsView() -> WorkoutStatsView {
        let viewModel = makeWorkoutStatsViewModel()
        
        return WorkoutStatsView(viewModel: viewModel)
    }
}

//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AppDIContainer {
    
    // Auth
    lazy var authService: AuthRepositoryProtocol = {
        FirebaseAuthService()
        
    }()
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(authService: authService)
    }
    
    // Exercise Librari
    
    lazy var exerciseService: ExerciseRepositoryProtocol = {
        return FirebaseExerciseService()
    }()
    
    func makeExerciseViewModel() -> ExerciseViewModel {
        let currentUserId = authService.currentUser?.id ?? ""
        return ExerciseViewModel(exerciseService: exerciseService, userId: currentUserId)
    }
    
    func makeExerciseViewController() -> ExerciesViewController {
        let viewModel = makeExerciseViewModel()
        return ExerciesViewController(viewModel: viewModel, diContainer: AppDIContainer())
    }
    
    func makeCustomExerciseViewModel() -> CustomExerciseViewModel {
        let currentUserId = authService.currentUser?.id ?? ""
        return CustomExerciseViewModel(exerciseService: exerciseService, userId: currentUserId)
    }
    
    // Templates
    
    lazy var templatesService: TemplatesRepositoryProtocol = {
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
    
    private lazy var workoutManager: WorkoutSessionRepositoryProtocol = {
        return WorkoutManager()
    }()
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        return ActiveWorkoutViewModel(workoutService: WorkoutManager.shared)
    }
    
    // Workout History
    
    lazy var workoutHistoryService: WorkoutHistoryRepositoryProtocol = {
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

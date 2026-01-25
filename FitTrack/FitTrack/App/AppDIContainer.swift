//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AppDIContainer {
    
    // Repositories
    
    lazy var authRepository: AuthRepositoryProtocol = {
        FirebaseAuthRepository()
    }()
    
    lazy var exerciseRepository: ExerciseRepositoryProtocol = {
        FirebaseExerciseRepository()
    }()
    
    lazy var templatesRepository: TemplatesRepositoryProtocol = {
        FirebaseTemplateRepository()
    }()
    
    lazy var workoutHistoryRepository: WorkoutHistoryRepositoryProtocol = {
        FirebaseWorkoutHistoryRepository()
    }()
    
    lazy var workoutStateRepository: WorkoutStateRepositoryProtocol = {
        UserDefaultsWorkoutStateRepository()
    }()
    
    lazy var restTimerRepository: RestTimerRepositoryProtocol = {
        UserDefaultsRestTimerRepository()
    }()
    
    lazy var healthKitRepository: HealthKitRepositoryProtocol = {
        HealthKitService()
    }()
    
    // Services
    
    private lazy var backgroundAudioService: BackgroundAudioService = {
        BackgroundAudioService()
    }()
    
    lazy var liveActivityService: LiveActivityService? = {
        if #available(iOS 16.1, *) {
            return LiveActivityService()
        }
        return nil
    }()
    
    private lazy var notificationService: NotificationService = {
        NotificationService()
    }()
    
    // Observers
    
    lazy var workoutStateObserver: WorkoutStateObserver = {
        WorkoutStateObserver(
            workoutStateRepository: workoutStateRepository,
            liveActivityService: liveActivityService
        )
    }()
    
    // Auth
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: authRepository)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: authRepository)
    }
    
    // Exercise Library
    
    func makeExerciseViewModel() -> ExerciseViewModel {
        let currentUserId = authRepository.currentUser?.id ?? ""
        return ExerciseViewModel(
            exerciseService: exerciseRepository,
            userId: currentUserId
        )
    }
    
    func makeExerciseViewController() -> ExerciesViewController {
        let viewModel = makeExerciseViewModel()
        return ExerciesViewController(viewModel: viewModel, diContainer: self)
    }
    
    func makeCustomExerciseViewModel() -> CustomExerciseViewModel {
        let currentUserId = authRepository.currentUser?.id ?? ""
        return CustomExerciseViewModel(
            exerciseService: exerciseRepository,
            userId: currentUserId
        )
    }
    
    // Templates
    
    func makeTemplatesViewModel() -> TemplatesViewModel {
        TemplatesViewModel(
            templatesService: templatesRepository,
            authService: authRepository
        )
    }
    
    func makeTemplatesViewController() -> TemplatesViewController {
        let viewModel = makeTemplatesViewModel()
        return TemplatesViewController(viewModel: viewModel)
    }
    
    func makeTemplateDetailsViewModel() -> TemplateDetailsViewModel {
        TemplateDetailsViewModel(
            templatesService: templatesRepository,
            authService: authRepository
        )
    }
    
    // Active Workouts
    
    func makeActiveWorkoutViewModel() -> ActiveWorkoutViewModel {
        let restTimer = RestTimerManager(
            restTimerRepository: restTimerRepository,
            notificationService: notificationService
        )
        
        return ActiveWorkoutViewModel(
            workoutStateRepository: workoutStateRepository,
            workoutHistoryRepository: workoutHistoryRepository,
            healthKitRepository: healthKitRepository,
            backgroundAudioService: backgroundAudioService,
            liveActivityService: liveActivityService,
            notificationService: notificationService,
            restTimer: restTimer
        )
    }
    
    // Workout History
    
    func makeWorkoutHistoryViewModel() -> WorkoutHistoryViewModel {
        let currentUserId = authRepository.currentUser?.id ?? "No User"
        
        return WorkoutHistoryViewModel(
            workoutHistoryService: workoutHistoryRepository,
            userId: currentUserId
        )
    }
    
    func makeWorkoutHistoryViewController() -> WorkoutHistoryViewController {
        let viewModel = makeWorkoutHistoryViewModel()
        return WorkoutHistoryViewController(viewModel: viewModel)
    }
    
    func makeWorkoutStatsViewModel() -> WorkoutStatsViewModel {
        let currentUserId = authRepository.currentUser?.id ?? "No User"
        
        return WorkoutStatsViewModel(
            workoutHistoryService: workoutHistoryRepository,
            userId: currentUserId
        )
    }
    
    func makeWorkoutStatsView() -> WorkoutStatsView {
        let viewModel = makeWorkoutStatsViewModel()
        return WorkoutStatsView(viewModel: viewModel)
    }
}

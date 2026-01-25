//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AppDIContainer {
    
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
    
    lazy var healthKitActivityRepository: HealthKitActivityRepositoryProtocol = {
        HealthKitActivityRepository()
    }()
    
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
    
    lazy var workoutStateObserver: WorkoutStateObserver = {
        WorkoutStateObserver(
            workoutStateRepository: workoutStateRepository,
            liveActivityService: liveActivityService
        )
    }()
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authService: authRepository)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: authRepository)
    }
    
    func makeExerciseViewModel() -> ExerciseViewModel {
        let currentUserId = authRepository.currentUser?.id ?? ""
        return ExerciseViewModel(
            exerciseService: exerciseRepository,
            userId: currentUserId
        )
    }
    
    func makeExerciseViewController() -> ExercisesViewController {
        let viewModel = makeExerciseViewModel()
        return ExercisesViewController(viewModel: viewModel, diContainer: self)
    }
    
    func makeCustomExerciseViewModel() -> CustomExerciseViewModel {
        let currentUserId = authRepository.currentUser?.id ?? ""
        return CustomExerciseViewModel(
            exerciseService: exerciseRepository,
            userId: currentUserId
        )
    }
    
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
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            healthKitActivityRepository: healthKitActivityRepository,
            authRepository: authRepository
        )
    }
    
    func makeMonthWorkoutsViewModel() -> MonthWorkoutsViewModel {
        MonthWorkoutsViewModel(
            healthKitActivityRepository: healthKitActivityRepository
        )
    }
}

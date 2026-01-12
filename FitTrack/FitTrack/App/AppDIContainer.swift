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
        return MockTemplateService()
    }()
    
    func makeTemplatesViewModel() -> TemplatesViewModel {
        return TemplatesViewModel(templatesService: templatesService)
    }
    
    func makeTemplatesViewController() -> TemplatesViewController {
        let viewModel = makeTemplatesViewModel()
        return TemplatesViewController(viewModel: viewModel)
    }
}

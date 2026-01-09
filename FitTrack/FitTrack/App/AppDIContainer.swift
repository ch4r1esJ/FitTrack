//
//  AuthDIContainer.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/4/26.
//

import Foundation

final class AppDIContainer {
    lazy var authService: AuthServiceProtocol = {
        FirebaseAuthService()
        
    }()
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
    func makeRegisterViewModel() -> RegisterViewModel {
        return RegisterViewModel(authService: authService)
    }
    
    lazy var exerciseService: ExerciseServiceProtocol = {
        return MockExerciseService()
    }()
    
    func makeExerciseViewModel() -> ExerciseViewModel {
        return ExerciseViewModel(exerciseService: exerciseService)
    }
    
    func makeExerciseViewController() -> ExerciesViewController {
        let viewModel = makeExerciseViewModel()
        return ExerciesViewController(viewModel: viewModel)
    }
}

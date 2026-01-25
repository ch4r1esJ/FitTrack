//
//  MonthWorkoutsViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/25/26.
//

import SwiftUI
import Combine

class MonthWorkoutsViewModel: ObservableObject {
    
    @Published var selectedMonth = 0
    @Published var selectedDate = Date()
    @Published var showAlert = false
    var fetchedMonths: Set<String> = []
    
    @Published var workouts = [Workout]()
    @Published var currentMonthWorkouts = [Workout]()
    
    private let healthKitActivityRepository: HealthKitActivityRepositoryProtocol
    
    init(healthKitActivityRepository: HealthKitActivityRepositoryProtocol) {
        self.healthKitActivityRepository = healthKitActivityRepository
        fetchWorkoutsForMonth()
    }
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
        
        if fetchedMonths.contains(selectedDate.monthAndYearFormat()) {
            self.currentMonthWorkouts = workouts.filter({ $0.date.monthAndYearFormat() == selectedDate.monthAndYearFormat() })
        } else {
            fetchWorkoutsForMonth()
        }
    }
    
    func fetchWorkoutsForMonth() {
        healthKitActivityRepository.fetchWorkoutsForMonth(selectedDate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newWorkouts):
                DispatchQueue.main.async {
                    self.workouts.append(contentsOf: newWorkouts)
                    self.fetchedMonths.insert(self.selectedDate.monthAndYearFormat())
                    self.currentMonthWorkouts = self.workouts.filter({ $0.date.monthAndYearFormat() == self.selectedDate.monthAndYearFormat() })
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
}

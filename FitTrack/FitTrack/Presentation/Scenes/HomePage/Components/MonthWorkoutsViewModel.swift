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
        
        Task {
            await fetchWorkoutsForMonth()
        }
    }
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
        
        if fetchedMonths.contains(selectedDate.monthAndYearFormat()) {
            self.currentMonthWorkouts = workouts.filter({ $0.date.monthAndYearFormat() == selectedDate.monthAndYearFormat() })
        } else {
            Task {
                await fetchWorkoutsForMonth()
            }
        }
    }
    
    func fetchWorkoutsForMonth() async {
        do {
            let summaries = try await healthKitActivityRepository.fetchWorkoutsForMonth(selectedDate)
            
            await MainActor.run {
                let newWorkouts = summaries.map { summary in
                    Workout(
                        title: summary.title,
                        image: summary.imageName,
                        tintcolor: summary.color.toColor(),
                        duration: "\(summary.durationMinutes) min",
                        date: summary.date,
                        calories: summary.calories.map { "\($0.formattedNumbersString()) kcal" } ?? "---",
                        isFromFitTrack: summary.isFromFitTrack
                    )
                }
                
                self.workouts.append(contentsOf: newWorkouts)
                self.fetchedMonths.insert(self.selectedDate.monthAndYearFormat())
                self.currentMonthWorkouts = self.workouts.filter({ $0.date.monthAndYearFormat() == self.selectedDate.monthAndYearFormat() })
            }
        } catch {
            await MainActor.run {
                self.showAlert = true
            }
        }
    }
}

//
//  MonthWorkoutsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
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
    
    init() {
        Task {
            do {
                try await fetchWorkoutsForMonth()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
        
        if fetchedMonths.contains(selectedDate.monthAndYearFormat()) {
            self.currentMonthWorkouts = workouts.filter({ $0.date.monthAndYearFormat() == selectedDate.monthAndYearFormat() })
        } else {
            Task {
                do {
                    try await fetchWorkoutsForMonth()
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func fetchWorkoutsForMonth() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchWorkoutsForMonth(month: selectedDate) { result in
                switch result {
                case .success(let workouts):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.workouts.append(contentsOf: workouts)
                        self.fetchedMonths.insert(self.selectedDate.monthAndYearFormat())
                        self.currentMonthWorkouts = self.workouts.filter({ $0.date.monthAndYearFormat() == self.selectedDate.monthAndYearFormat() })
                        continuation.resume()
                    }
                case .failure(_):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.showAlert = true
                        continuation.resume()
                    }
                }
            }
        }) as Void
    }
}
struct MonthWorkoutsView: View {
    @StateObject var viewModel = MonthWorkoutsViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.selectedMonth -= 1
                    }
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue)
                }
                
                Spacer()
                
                Text(viewModel.selectedDate.monthAndYearFormat())
                    .font(.title)
                    .frame(maxWidth: 250)
                
                Spacer()
                
                Button {
                    viewModel.selectedMonth += 1
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .opacity(viewModel.selectedMonth >= 0 ? 0.5 : 1)
                }
                .disabled(viewModel.selectedMonth >= 0)
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.currentMonthWorkouts, id: \.self) { workout in
                    WorkoutCard(workout: workout)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.vertical)
        .onChange(of: viewModel.selectedMonth) { _ in
            viewModel.updateSelectedDate()
        }
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Text("Okay")
        } message: {
            Text("Unable to load workouts for \(viewModel.selectedDate.monthAndYearFormat()). Please, try again and make sure you have workouts selected.")
        }
    }
}

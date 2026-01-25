//
//  MonthWorkoutsView.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/21/26.
//

import SwiftUI
import Combine

struct MonthWorkoutsView: View {
    @StateObject var viewModel: MonthWorkoutsViewModel
    
    init(viewModel: MonthWorkoutsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
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

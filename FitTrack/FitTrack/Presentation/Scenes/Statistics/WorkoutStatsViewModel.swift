//
//  WorkoutStatsViewModel.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/19/26.
//

import Foundation
import Combine

class WorkoutStatsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var workouts: [CompletedWorkout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var workoutsThisWeek: Int = 0
    @Published var workoutsThisMonth: Int = 0
    @Published var totalVolumeThisMonth: String = "0"
    @Published var currentStreak: Int = 0
    
    @Published var weeklyWorkoutData: [WeeklyWorkoutData] = []
    @Published var weeklyVolumeData: [WeeklyVolumeData] = []
    @Published var muscleGroupData: [MuscleGroupData] = []
    @Published var personalRecords: [PersonalRecord] = []
    
    @Published var durationViewMode: DurationViewMode = .weekly
    
    @Published var weeklyDurationByDayData: [DayDurationData] = []
    @Published var monthlyDurationData: [WeekDurationData] = []
    @Published var totalTimeThisWeek: String = "-"
    @Published var averageWorkoutDuration: String = "-"
    @Published var totalTimeThisMonth: String = "-"
    @Published var averageTimePerWeek: String = "-"
    
    private let workoutHistoryService: WorkoutHistoryRepositoryProtocol
    private let userId: String
    private let calendar = Calendar.current
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        workoutHistoryService: WorkoutHistoryRepositoryProtocol,
        userId: String
    ) {
        self.workoutHistoryService = workoutHistoryService
        self.userId = userId
    }
    
    func loadWorkouts() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedWorkouts = try await workoutHistoryService.fetchUserWorkoutHistory(
                    userId: userId,
                    limit: nil
                )
                
                await MainActor.run {
                    self.workouts = fetchedWorkouts
                    self.calculateStats()
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Failed to load workouts: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func calculateStats() {
        calculateSummaryStats()
        calculateWeeklyWorkoutData()
        calculateWeeklyVolumeData()
        calculateMuscleGroupData()
        calculatePersonalRecords()
        
        calculateWeeklyDurationByDay()
        calculateMonthlyDurationByWeek()
    }
    
    private func calculateSummaryStats() {
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        workoutsThisWeek = workouts.filter { $0.endDate >= weekStart }.count
        
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let monthWorkouts = workouts.filter { $0.endDate >= monthStart }
        workoutsThisMonth = monthWorkouts.count
        
        let monthVolume = monthWorkouts.reduce(0.0) { $0 + $1.totalVolume }
        totalVolumeThisMonth = formatVolume(monthVolume)
        
        currentStreak = calculateStreak()
    }
    
    private func calculateStreak() -> Int {
        guard !workouts.isEmpty else { return 0 }
        
        let sortedWorkouts = workouts.sorted { $0.endDate > $1.endDate }
        var streak = 0
        var checkDate = Date()
        
        let hasWorkoutToday = sortedWorkouts.contains { calendar.isDateInToday($0.endDate) }
        let hasWorkoutYesterday = sortedWorkouts.contains {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()) else { return false }
            return calendar.isDate($0.endDate, inSameDayAs: yesterday)
        }
        
        if !hasWorkoutToday && !hasWorkoutYesterday {
            return 0
        }
        
        if !hasWorkoutToday && hasWorkoutYesterday {
            checkDate = calendar.date(byAdding: .day, value: -1, to: Date())!
        }
        
        var daysChecked = 0
        while daysChecked < 365 {
            let hasWorkout = sortedWorkouts.contains { calendar.isDate($0.endDate, inSameDayAs: checkDate) }
            
            if hasWorkout {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else {
                break
            }
            
            daysChecked += 1
        }
        
        return streak
    }
    
    private func calculateWeeklyWorkoutData() {
        var data: [WeeklyWorkoutData] = []
        
        for weekOffset in (0..<8).reversed() {
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()),
                  let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
                continue
            }
            
            let weekWorkouts = workouts.filter { workout in
                workout.endDate >= weekStart && workout.endDate < weekEnd
            }
            
            let weekLabel = formatWeekLabel(weekStart, offset: weekOffset)
            data.append(WeeklyWorkoutData(weekLabel: weekLabel, count: weekWorkouts.count, weekStart: weekStart))
        }
        
        weeklyWorkoutData = data
    }
    
    private func calculateWeeklyVolumeData() {
        var data: [WeeklyVolumeData] = []
        
        for weekOffset in (0..<8).reversed() {
            guard let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: Date()),
                  let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
                continue
            }
            
            let weekWorkouts = workouts.filter { workout in
                workout.endDate >= weekStart && workout.endDate < weekEnd
            }
            
            let totalVolume = weekWorkouts.reduce(0.0) { $0 + $1.totalVolume }
            let weekLabel = formatWeekLabel(weekStart, offset: weekOffset)
            
            data.append(WeeklyVolumeData(weekLabel: weekLabel, volume: totalVolume, weekStart: weekStart))
        }
        
        weeklyVolumeData = data
    }
    
    private func calculateWeeklyDurationByDay() {
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return }
        
        guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { return }
        
        let thisWeekWorkouts = workouts.filter { workout in
            workout.endDate >= weekStart && workout.endDate < weekEnd
        }
        
        var dayDurations: [Int: TimeInterval] = [:]
        
        for workout in thisWeekWorkouts {
            let weekday = calendar.component(.weekday, from: workout.endDate)
            dayDurations[weekday, default: 0] += workout.duration
        }
        
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var data: [DayDurationData] = []
        
        for weekday in 1...7 {
            let totalSeconds = dayDurations[weekday] ?? 0
            let totalMinutes = totalSeconds / 60.0
            
            data.append(DayDurationData(
                dayName: dayNames[weekday - 1],
                averageDuration: totalMinutes,
                weekday: weekday
            ))
        }
        
        weeklyDurationByDayData = data
        
        let totalSecondsThisWeek = thisWeekWorkouts.reduce(0.0) { $0 + $1.duration }
            totalTimeThisWeek = formatDuration(totalSecondsThisWeek)
        
        let totalDuration = workouts.reduce(0.0) { $0 + $1.duration }
        let avgDuration = workouts.isEmpty ? 0 : totalDuration / Double(workouts.count)
        averageWorkoutDuration = formatDuration(avgDuration)
    }
    
    private func calculateMonthlyDurationByWeek() {
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let monthWorkouts = workouts.filter { $0.endDate >= monthStart }
        
        var weekDurations: [Date: TimeInterval] = [:]
        
        for workout in monthWorkouts {
            if let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: workout.endDate)) {
                weekDurations[weekStart, default: 0] += workout.duration
            }
        }
        
        var data: [WeekDurationData] = weekDurations.map { (weekStart, duration) in
            let weekNumber = calendar.component(.weekOfMonth, from: weekStart)
            return WeekDurationData(
                weekLabel: "Week \(weekNumber)",
                totalDuration: duration / 60.0,
                weekStart: weekStart
            )
        }.sorted { $0.weekStart < $1.weekStart }
        
        monthlyDurationData = data
        
        let monthTotalDuration = monthWorkouts.reduce(0.0) { $0 + $1.duration }
        totalTimeThisMonth = formatDuration(monthTotalDuration)
        
        let avgPerWeek = data.isEmpty ? 0 : data.map { $0.totalDuration }.reduce(0, +) / Double(data.count)
        averageTimePerWeek = formatDurationMinutes(avgPerWeek)
    }
    
    private func calculateMuscleGroupData() {
        var muscleGroupCounts: [String: Int] = [:]
        
        for workout in workouts {
            for exercise in workout.exercises {
                let muscleGroup = exercise.muscleGroup.lowercased()
                muscleGroupCounts[muscleGroup, default: 0] += 1
            }
        }
        
        let totalExercises = muscleGroupCounts.values.reduce(0, +)
        
        var data: [MuscleGroupData] = muscleGroupCounts.map { (key, value) in
            let percentage = totalExercises > 0 ? Int((Double(value) / Double(totalExercises)) * 100) : 0
            return MuscleGroupData(
                muscleGroup: key,
                count: value,
                percentage: percentage
            )
        }
        
        data.sort { $0.count > $1.count }
        
        muscleGroupData = data
    }
    
    private func calculatePersonalRecords() {
        var exerciseRecords: [String: PersonalRecord] = [:]
        
        for workout in workouts {
            for exercise in workout.exercises {
                for set in exercise.sets where set.isCompleted {
                    guard let weight = set.actualWeightKg,
                          let reps = set.actualReps else { continue }
                    
                    let exerciseName = exercise.exerciseName
                    
                    if let existingRecord = exerciseRecords[exerciseName] {
                        if weight > existingRecord.weight ||
                            (weight == existingRecord.weight && reps > existingRecord.reps) {
                            exerciseRecords[exerciseName] = PersonalRecord(
                                id: UUID().uuidString,
                                exerciseName: exerciseName,
                                weight: weight,
                                reps: reps,
                                date: workout.endDate
                            )
                        }
                    } else {
                        exerciseRecords[exerciseName] = PersonalRecord(
                            id: UUID().uuidString,
                            exerciseName: exerciseName,
                            weight: weight,
                            reps: reps,
                            date: workout.endDate
                        )
                    }
                }
            }
        }
        
        personalRecords = Array(exerciseRecords.values).sorted { $0.date > $1.date }
    }
    
    private func formatWeekLabel(_ date: Date, offset: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func formatVolume(_ volume: Double) -> String {
        if volume >= 1000 {
            return String(format: "%.1fk", volume / 1000)
        } else {
            return String(format: "%.0f", volume)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formatDurationMinutes(_ minutes: Double) -> String {
        let hours = Int(minutes) / 60
        let mins = Int(minutes) % 60
        
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(Int(mins))m"
        }
    }
}

enum DurationViewMode {
    case weekly
    case monthly
}

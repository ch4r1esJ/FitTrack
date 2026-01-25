//
//  WorkoutTimerManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/24/26.
//

import Foundation
import Combine

class WorkoutTimerManager {
    
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var formattedTime: String = "00:00"
    
    private var timer: Timer?
    private(set) var startDate: Date?
    
    func startTimer(from date: Date = Date()) {
        stopTimer()
        
        startDate = date
        elapsedSeconds = 0
        updateFormattedTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedSeconds += 1
            self.updateFormattedTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer(withElapsedTime elapsed: TimeInterval, startDate: Date) {
        stopTimer()
        
        self.startDate = startDate
        self.elapsedSeconds = elapsed
        updateFormattedTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedSeconds += 1
            self.updateFormattedTime()
        }
    }
    
    func reset() {
        stopTimer()
        elapsedSeconds = 0
        startDate = nil
        updateFormattedTime()
    }
    
    private func updateFormattedTime() {
        formattedTime = formatTime(elapsedSeconds)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds) ?? "00:00"
    }
}

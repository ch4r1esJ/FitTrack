//
//  RestTimerManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import Foundation
import Combine
import AVFoundation

class RestTimerManager: ObservableObject {
    @Published var isActive: Bool = false
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    
    private var timer: Timer?
    private var endTime: Date?
    private var audioPlayer: AVAudioPlayer?
    private let notificationManager = NotificationManager.shared
    
    init() {
        loadPersistedTimer()
    }
    
    func startRestTimer(seconds: Int) {
        guard seconds > 0 else { return }
        
        self.totalSeconds = seconds
        self.remainingSeconds = seconds
        self.endTime = Date().addingTimeInterval(TimeInterval(seconds))
        self.isActive = true
        
        notificationManager.scheduleRestTimerNotification(seconds: seconds)
        
        persistTimer()
        
        startTicking()
    }
    
    func adjustTime(by seconds: Int) {
        guard let currentEndTime = endTime else { return }
        
        let newEndTime = currentEndTime.addingTimeInterval(TimeInterval(seconds))
        self.endTime = newEndTime
        
        let newRemaining = Int(newEndTime.timeIntervalSinceNow)
        
        if newRemaining <= 0 {
            skip()
        } else {
            remainingSeconds = newRemaining
            totalSeconds = newRemaining
            
            persistTimer()
            
            notificationManager.cancelRestTimerNotification()
            notificationManager.scheduleRestTimerNotification(seconds: newRemaining)
        }
    }
    
    func skip() {
        stop()
        notificationManager.cancelRestTimerNotification()
        RestTimerPersistence.clearRestTimer()
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        notificationManager.cancelRestTimerNotification()
        persistTimer()
    }
    
    func resumeIfNeeded() {
        guard isActive, let endTime = endTime else { return }
        
        let timeRemaining = endTime.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            finish()
        } else {
            remainingSeconds = Int(ceil(timeRemaining))
            notificationManager.scheduleRestTimerNotification(seconds: remainingSeconds) 
            startTicking()
        }
    }
    
    private func loadPersistedTimer() {
        guard let persisted = RestTimerPersistence.loadRestTimer() else { return }
        
        self.endTime = persisted.endTime
        self.totalSeconds = persisted.totalSeconds
        
        let timeRemaining = persisted.endTime.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            finish()
        } else {
            self.remainingSeconds = Int(ceil(timeRemaining))
            self.isActive = true
            startTicking()
        }
    }
    
    private func persistTimer() {
        guard let endTime = endTime, isActive else { return }
        RestTimerPersistence.saveRestTimer(endTime: endTime, totalSeconds: totalSeconds)
    }
    
    private func startTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    private func tick() {
        guard let endTime = endTime else {
            stop()
            return
        }
        
        let timeRemaining = endTime.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            finish()
        } else {
            remainingSeconds = Int(ceil(timeRemaining))
        }
    }
    
    private func finish() {
        stop()
        playSound()
        notificationManager.cancelRestTimerNotification()
        RestTimerPersistence.clearRestTimer()
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
        isActive = false
        remainingSeconds = 0
        totalSeconds = 0
        endTime = nil
    }

    private func playSound() {
        AudioServicesPlaySystemSound(1304)
    }
}

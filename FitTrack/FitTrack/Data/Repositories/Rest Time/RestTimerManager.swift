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
    
    private let restTimerRepository: RestTimerRepositoryProtocol
    private let notificationService: NotificationService
    
    // MARK: - Properties
    
    private var timer: Timer?
    private var endTime: Date?
    
    // MARK: - Init
    
    init(
        restTimerRepository: RestTimerRepositoryProtocol,
        notificationService: NotificationService
    ) {
        self.restTimerRepository = restTimerRepository
        self.notificationService = notificationService
        
        loadPersistedTimer()
    }
    
    // MARK: - Methods
    
    func startRestTimer(seconds: Int) {
        guard seconds > 0 else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.totalSeconds = seconds
            self.remainingSeconds = seconds
            self.endTime = Date().addingTimeInterval(TimeInterval(seconds))
            self.isActive = true
            
            self.notificationService.scheduleRestTimerNotification(seconds: seconds)
            
            self.persistTimer()
            self.startTicking()
        }
    }
    
    func adjustTime(by seconds: Int) {
        guard let currentEndTime = endTime else { return }
        
        let newEndTime = currentEndTime.addingTimeInterval(TimeInterval(seconds))
        let newRemaining = Int(newEndTime.timeIntervalSinceNow)
        
        if newRemaining <= 0 {
            skip()
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.endTime = newEndTime
                self.remainingSeconds = newRemaining
                self.totalSeconds = newRemaining
                
                self.persistTimer()
                
                self.notificationService.cancelRestTimerNotification()
                self.notificationService.scheduleRestTimerNotification(seconds: newRemaining)
            }
        }
    }
    
    func skip() {
        stop()
        notificationService.cancelRestTimerNotification()
        try? restTimerRepository.clearRestTimerState()
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        notificationService.cancelRestTimerNotification()
        persistTimer()
    }
    
    func resumeIfNeeded() {
        guard isActive, let endTime = endTime else { return }
        
        let timeRemaining = endTime.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            finish(isPlayingSound: false)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.remainingSeconds = Int(ceil(timeRemaining))
                self.notificationService.scheduleRestTimerNotification(seconds: self.remainingSeconds)
                self.startTicking()
            }
        }
    }
    
    private func loadPersistedTimer() {
        guard let persisted = try? restTimerRepository.loadRestTimerState() else {
            return
        }
        
        self.endTime = persisted.endTime
        self.totalSeconds = persisted.totalSeconds
        
        let timeRemaining = persisted.endTime.timeIntervalSinceNow
        
        if timeRemaining <= 0 {
            finish(isPlayingSound: false)

        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.remainingSeconds = Int(ceil(timeRemaining))
                self.isActive = true
                self.startTicking()
            }
        }
    }
    
    private func persistTimer() {
        guard let endTime = endTime, isActive else { return }
        
        let state = RestTimerState(endTime: endTime, totalSeconds: totalSeconds)
        try? restTimerRepository.saveRestTimerState(state)
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
            DispatchQueue.main.async { [weak self] in
                self?.remainingSeconds = Int(ceil(timeRemaining))
            }
        }
    }
    
    private func finish(isPlayingSound: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.stop()
            if isPlayingSound {
                self?.playSound()
            }
            self?.notificationService.cancelRestTimerNotification()
            try? self?.restTimerRepository.clearRestTimerState()
        }
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

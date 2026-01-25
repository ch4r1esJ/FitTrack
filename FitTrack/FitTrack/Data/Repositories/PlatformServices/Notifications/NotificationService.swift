//
//  NotificationService.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import UserNotifications

class NotificationService {
    
    // MARK: - Methods
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        }
    }
    
    func scheduleRestTimerNotification(seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Rest Timer Complete"
        content.body = "Time to start your next set!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        let request = UNNotificationRequest(identifier: "restTimer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { _ in }
    }
    
    func cancelRestTimerNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["restTimer"])
    }
}

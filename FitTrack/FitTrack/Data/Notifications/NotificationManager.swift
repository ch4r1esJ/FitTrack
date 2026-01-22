//
//  NotificationManager.swift
//  FitTrack
//
//  Created by Charles Janjgava on 1/17/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let restTimerIdentifier = "rest_timer_notification"
    
    private init() {}
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        }
    }
    
    func scheduleRestTimerNotification(seconds: Int) {
        cancelRestTimerNotification()
        
        let content = UNMutableNotificationContent()
        content.title = "Rest Complete!"
        content.body = "Time to start your next set 💪"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: restTimerIdentifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
        }
    }
    
    func cancelRestTimerNotification() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [restTimerIdentifier])
    }
}

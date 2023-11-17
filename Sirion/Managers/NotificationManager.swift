//
//  NotificationManager.swift
//  Sirion
//
//  Created by IC Deis on 7/27/23.
//

import Foundation
import UserNotifications

class NotificationManager {
   static let shared = NotificationManager()
   
   func askPermission() {
      let options: UNAuthorizationOptions = [.alert, .sound, .badge]
      UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
         if let error = error {
            print("Error: \(error)")
         } else {
            print("Success")
         }
      }
   }
   
   func scheduleNotification(title: String, subtitle: String, count: Int) {
      let content = UNMutableNotificationContent()
      content.title = title
      content.subtitle = subtitle
      content.sound = .default
      content.badge = count as NSNumber
      
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
      UNUserNotificationCenter.current().add(request)
   }
   
   func cancelNotification() {
      UNUserNotificationCenter.current().removeAllDeliveredNotifications()
      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
   }
}

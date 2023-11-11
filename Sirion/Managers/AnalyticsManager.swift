//
//  AnalyticsManager.swift
//  InstaDC
//
//  Created by IC Deis on 7/1/23.
//

import FirebaseAnalytics

/// Firebase Analytics Manager class that helps to monitor some feature usage
class AnalyticsManager {
   
   static let shared = AnalyticsManager()
   private init() { }
   
   /// Firebase Analytics: monitoring "double tap to like"
   func likeDoubleTap(username: String) {
      Analytics.logEvent("likeDoubleTap", parameters: ["username": username])
   }
   
   /// Firebase Analytics: monitoring "tap heart button to like"
   func likeHeartPressed(username: String) {
      Analytics.logEvent("likeHeartPressed", parameters: ["username": username])
   }
   
}

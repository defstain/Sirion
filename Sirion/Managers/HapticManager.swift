//
//  HapticManager.swift
//  InstaDC
//
//  Created by IC Deis on 7/27/23.
//

import SwiftUI

/// Haptic manager class
class HapticManager {
   
   static let shared = HapticManager()
   
   /// Generates haptic with the given parameter
   func genHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(type)
   }
   
   /// Generates impact with the given parameter
   func genImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.impactOccurred()
   }
   
}

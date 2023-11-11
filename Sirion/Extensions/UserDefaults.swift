//
//  UserDefaults.swift
//  Sirion
//
//  Created by IC Deis on 10/30/23.
//

import Foundation

extension UserDefaults {
   
   /// This methods clears all saved data from Userdefaults
   static func resetAllSavedData() {
      if let bundleID = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundleID)
      }
   }
   
}

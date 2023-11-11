//
//  Date.swift
//  SmallProject3
//
//  Created by IC Deis on 5/20/23.
//

import Foundation

extension Date {
   
   /// This function returns time distance from
   ///```
   ///   convert given time -> 10 minutes ago
   ///   convert given time -> 3 hours ago
   ///   convert given time -> 2 days ago
   ///```
   func getTimeSince(date: Date) -> String {
      let minutes = Int(-date.timeIntervalSinceNow) / 60
      let hours = minutes / 60
      let days = hours / 24
      
      if minutes < 120 {
         return "\(minutes) minutes ago"
      } else if minutes >= 120 && hours < 48 {
         return "\(hours) hours ago"
      } else  {
         return "\(days) days ago"
      }
   }
   
   
   init(coinDate: String) {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-DD'T'HH:mm:ss.SSSZ"
      let date = formatter.date(from: coinDate) ?? Date()
      self.init(timeInterval: 0, since: date)
   }
   
   
   
   private func shortFormatter(type: DateFormatter.Style) -> DateFormatter {
      let formatter = DateFormatter()
      formatter.dateStyle = type
      return formatter
   }
   
   /// This function returns time as a String
   ///```
   ///   return as '01/01/23
   ///```
   func asString(_ type: DateFormatter.Style) -> String {
      return shortFormatter(type: type).string(from: self)
   }
   
   
   
}

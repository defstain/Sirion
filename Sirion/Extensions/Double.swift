//
//  Double.swift
//  SmallProject3
//
//  Created by IC Deis on 5/20/23.
//

import Foundation

extension Double {
   
   /// Returns the double value as a string
    func asString() -> String {
       String(self)
    }
   
   /// converts a Double into a Currency with 2 decimal places
   ///```
   ///  Convert 1234.56 -> $1,234.56
   ///```
   private var currencyFormatter2: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }
   
   /// converts a Double into a Currency as a String with 2 decimal places
   ///```
   ///  Convert 1234.56 -> "$1,234.56"
   ///```
   func asCurrency2Decimals() -> String {
      let number = NSNumber(value: self)
      return currencyFormatter2.string(from: number) ?? "0.00"
   }
   
   /// converts a Double into a Currency with 2-5 decimal places
   ///```
   ///  Convert 1234.56 -> $1,234.56
   ///  Convert 12.3456 -> $12,3456
   ///  Convert 0.123456 -> $0.12345
   ///```
   private var currencyFormatter5: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.usesGroupingSeparator = true
      formatter.numberStyle = .currency
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 5
      return formatter
   }
   
   /// converts a Double into a Currency as a String with 2-5 decimal places
   ///```
   ///  Convert 1234.56 -> "$1,234.56"
   ///  Convert 12.3456 -> "$12,3456"
   ///  Convert 0.123456 -> "$0.12345"
   ///```
   func asCurrency5Decimals() -> String {
      let number = NSNumber(value: self)
      return currencyFormatter5.string(from: number) ?? "$0.00"
   }
   
   /// converts a Double into string representation
   ///```
   ///  Convert 1.23456 -> "1.23"
   ///```
   func asNumberString() -> String {
      return String(format: "%.2f", self)
   }
   
   /// converts a Double into string representation with percent symbol
   ///```
   ///  Convert 1.23456 -> "1.23%"
   ///```
   func asPercentString() -> String {
      return asNumberString() + "%"
   }
   
   /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
   /// ```
   /// Convert 12 to 12.00
   /// Convert 1234 to 1.23K
   /// Convert 123456 to 123.45K
   /// Convert 12345678 to 12.34M
   /// Convert 1234567890 to 1.23Bn
   /// Convert 123456789012 to 123.45Bn
   /// Convert 12345678901234 to 12.34Tr
   /// ```
   func formattedWithAbbreviations() -> String {
      let num = abs(Double(self))
      let sign = (self < 0) ? "-" : ""
      
      switch num {
      case 1_000_000_000_000...:
         let formatted = num / 1_000_000_000_000
         let stringFormatted = formatted.asNumberString()
         return "\(sign)\(stringFormatted)Tr"
      case 1_000_000_000...:
         let formatted = num / 1_000_000_000
         let stringFormatted = formatted.asNumberString()
         return "\(sign)\(stringFormatted)Bn"
      case 1_000_000...:
         let formatted = num / 1_000_000
         let stringFormatted = formatted.asNumberString()
         return "\(sign)\(stringFormatted)M"
      case 1_000...:
         let formatted = num / 1_000
         let stringFormatted = formatted.asNumberString()
         return "\(sign)\(stringFormatted)K"
      case 0...:
         return self.asNumberString()
         
      default:
         return "\(sign)\(self)"
      }
   }
   
}

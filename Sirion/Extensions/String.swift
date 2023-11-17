//
//  String.swift
//  Sirion
//
//  Created by IC Deis on 7/6/23.
//

import SwiftUI

extension String {
   
   /// Add "@" sign before username and return string
   func asUsername() -> String {
      "@" + self
   }
   
   var asURL: URL? {
      return URL(string: self)
   }
   
   func addString(_ text: String, side: Side) -> Self {
      switch side {
      case .right: return self + " " + text
      case .left: return text + " " + self
      }
   }
 
   
   enum Side {
      case right
      case left
   }
}

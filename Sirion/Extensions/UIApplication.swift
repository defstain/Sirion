//
//  UIApplication.swift
//  InstaDC
//
//  Created by IC Deis on 6/21/23.
//

import SwiftUI

extension UIApplication {
   
   func currentUIWindow() -> UIWindow? {
      let connectedScenes = UIApplication.shared.connectedScenes
         .filter { $0.activationState == .foregroundActive }
         .compactMap { $0 as? UIWindowScene }
      
      let window = connectedScenes.first?
         .windows
         .first { $0.isKeyWindow }
      
      return window
   }
   
   func dismissKeyboard() {
      sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
   
}

/// Returns root view controller
func getRootViewController() -> UIViewController? {
   guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let window = windowScene.windows.first,
         let rootViewController = window.rootViewController else {
      return nil
   }
   return rootViewController
}




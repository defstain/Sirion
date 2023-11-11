//
//  UIViewController.swift
//  Yummie
//
//  Created by IC Deis on 10/9/23.
//

import UIKit

extension UIViewController {
   
   static var identifier: String {
      return String(describing: self)
   }
   
   static func instantiate(_ name: String = "Main") -> Self {
      let storyboard = UIStoryboard(name: name, bundle: nil)
      return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
   }
   
   func dismissKeyboard() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
   }
   
   @objc private func dismissKeyboardTouchOutside() {
      view.endEditing(true)
   }
   
   
   func tabbarColor(tint: UIColor, barTint: UIColor) {
      tabBarController?.tabBar.tintColor = tint
      tabBarController?.tabBar.barTintColor = barTint
   }
   
   
}

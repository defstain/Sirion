//
//  UITextField.swift
//  NetflixUI
//
//  Created by IC Deis on 9/21/23.
//

import UIKit

extension UITextField {
   func padding(left: CGFloat, right: CGFloat? = nil) {
      setLeftPadding(left)
      if let rightPadding = right {
         setRightPadding(rightPadding)
      }
   }
   
   private func setLeftPadding(_ padding: CGFloat) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
      self.leftView = paddingView
      self.leftViewMode = .always
   }
   
   private func setRightPadding(_ padding: CGFloat) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
      self.rightView = paddingView
      self.rightViewMode = .always
   }
}

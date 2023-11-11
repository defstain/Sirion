//
//  UIView.swift
//  WisarUI
//
//  Created by IC Deis on 8/29/23.
//

import UIKit
import SwiftUI

extension UIView {
   
   var width: CGFloat {
      return frame.size.width
   }
   
   var height: CGFloat {
      return frame.size.height
   }
   
   var right: CGFloat {
      return frame.origin.x + frame.size.width
   }
   
   var left: CGFloat {
      return frame.origin.x
   }
   
   var top: CGFloat {
      return frame.origin.y
   }
   
   var bottom: CGFloat {
      return frame.origin.y + frame.size.height
   }
   
   // adds field to storyboard
   @IBInspectable var cornerRadius: CGFloat {
      get { return self.cornerRadius }
      set { self.layer.cornerRadius = newValue }
   }
   
}
func getCoordinate(_ view: UIView) -> CGPoint {
   var x = view.frame.origin.x
   var y = view.frame.origin.y
   var oldView = view
   
   while let superView = oldView.superview {
      x += superView.frame.origin.x
      y += superView.frame.origin.y
      if superView.next is UIViewController {
         break //superView is the rootView of a UIViewController
      }
      oldView = superView
   }
   
   return CGPoint(x: x, y: y)
}


extension View {
   
   /// This function rounds the specified corner
   func cornerRadius (_ radius: CGFloat, corners: UIRectCorner) -> some View {
      clipShape(RoundedCorner(radius: radius, corners: corners) )
   }
   
}

   
struct RoundedCorner: Shape {
   var radius: CGFloat = .infinity
   var corners: UIRectCorner = .allCorners
   
   func path(in rect: CGRect) -> Path {
      let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize (width: radius, height: radius))
      return Path(path.cgPath)
   }
}


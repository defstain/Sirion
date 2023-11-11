//
//  Button.swift
//  Sirion
//
//  Created by IC Deis on 10/26/23.
//

import UIKit

extension UIButton {
   
   func setImageTintColor(_ color: UIColor) {
      let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
      self.setImage(tintedImage, for: .normal)
      self.tintColor = color
   }
   
   func setImage(_ image: UIImage, color: UIColor) {
      self.setImage(image, for: .normal)
      self.configuration?.baseForegroundColor = color
   }
   
}

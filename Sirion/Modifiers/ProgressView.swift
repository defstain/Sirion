//
//  ProgressView.swift
//  Sirion
//
//  Created by IC Deis on 10/29/23.
//

import UIKit

class ProgressView: UIActivityIndicatorView {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      style = .large
      backgroundColor = .systemGray4
      layer.cornerRadius = 12
      layer.shadowOffset = .zero
      layer.shadowRadius = 10
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.15
      clipsToBounds = true
   }
   
   required init(coder: NSCoder) {
      super.init(coder: coder)
   }
   
}

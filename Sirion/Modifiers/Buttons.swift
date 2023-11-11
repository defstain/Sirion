//
//  Buttons.swift
//  Sirion
//
//  Created by IC Deis on 10/30/23.
//

import UIKit

class FollowButton: UIButton {
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupView()
   }
   
   private func setupView() {
      setTitle("Follow", for: .normal)
      setTitleColor(.white, for: .normal)
      backgroundColor = .systemBlue
      layer.borderColor = UIColor.systemBlue.cgColor
      layer.borderWidth = 1
      layer.cornerRadius = 5
      clipsToBounds = true
   }
   
}

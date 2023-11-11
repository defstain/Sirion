//
//  RoundedField.swift
//  Teenary
//
//  Created by IC Deis on 10/12/23.
//

import UIKit

class RoundedField: UITextField {

   override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupView()
   }
   
   
   private func setupView() {
      backgroundColor = .systemBackground
      layer.cornerRadius = 10
      clipsToBounds = true
      layer.masksToBounds = true
      borderStyle = .none
      padding(left: 10, right: 10)
      font = .systemFont(ofSize: 17)
      clearButtonMode = .whileEditing
   }
   
}

class BorderedField: UITextField {

   override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupView()
   }
   
   
   private func setupView() {
      backgroundColor = .systemBackground
      layer.cornerRadius = 10
      layer.borderWidth = 1
      layer.borderColor = UIColor.systemBlue.cgColor
      clipsToBounds = true
      layer.masksToBounds = true
      borderStyle = .roundedRect
      padding(left: 5, right: 5)
      font = .systemFont(ofSize: 17)
      clearButtonMode = .whileEditing
   }
   
}


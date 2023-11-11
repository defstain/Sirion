//
//  HeaderForSettings.swift
//  Sirion
//
//  Created by IC Deis on 10/18/23.
//

import UIKit

class HeaderForSettings: UIView {

   private let appName: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = .systemFont(ofSize: 19, weight: .semibold)
      label.textColor = .label
      label.text = "Sirion"
      return label
   }()
   
   private let icon: UIImageView = {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.tintColor = .label
      imageView.contentMode = .scaleAspectFit
      imageView.image = UIImage(systemName: "tornado")
      return imageView
   }()
   
   private let appLogo: UIImageView = {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFill
      imageView.tintColor = .white
      imageView.layer.cornerRadius = 32.5
      imageView.clipsToBounds = true
      imageView.image = UIImage(named: "logo")
      return imageView
   }()

   private let appDescription: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = .systemFont(ofSize: 14)
      label.textColor = .label
      label.numberOfLines = 3
      label.minimumScaleFactor = 0.8
      label.text = "Our planet is beautiful with green plants, flowers and trees, that's why we have to try to do our best to keep that beautiful."
      return label
   }()
   
   private let divider: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = .systemGray3
      view.layer.cornerRadius = 2
      view.clipsToBounds = true
      return view
   }()
   
   
   // MARK: - View Initializations
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .systemGray6.withAlphaComponent(0.8)

      addSubview(appName)
      addSubview(icon)
      addSubview(appLogo)
      addSubview(appDescription)
      addSubview(divider)
      
      applyConstraints()
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   
   private func applyConstraints() {
      let constraints = [
         appName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
         appName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
         appName.heightAnchor.constraint(equalToConstant: 30),
         
         icon.topAnchor.constraint(equalTo: topAnchor, constant: 10),
         icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
         icon.widthAnchor.constraint(equalToConstant: 30),
         icon.heightAnchor.constraint(equalToConstant: 30),
         
         divider.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 8),
         divider.leadingAnchor.constraint(equalTo: appName.leadingAnchor),
         divider.trailingAnchor.constraint(equalTo: icon.trailingAnchor),
         divider.heightAnchor.constraint(equalToConstant: 1),
         
         appLogo.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
         appLogo.leadingAnchor.constraint(equalTo: appName.leadingAnchor),
         appLogo.widthAnchor.constraint(equalToConstant: 65),
         appLogo.heightAnchor.constraint(equalToConstant: 65),
         
         appDescription.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
         appDescription.leadingAnchor.constraint(equalTo: appLogo.trailingAnchor, constant: 10),
         appDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
         appDescription.heightAnchor.constraint(equalTo: appLogo.heightAnchor, multiplier: 1)
      ]
      
      NSLayoutConstraint.activate(constraints)
   }
   
}

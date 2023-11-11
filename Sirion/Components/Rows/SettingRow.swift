//
//  SettingRow.swift
//  Sirion
//
//  Created by IC Deis on 10/18/23.
//

import UIKit

class SettingRow: UITableViewCell {
   
   static var ID = "SettingRow"
   
   private let rowImageCona: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.layer.cornerRadius = 6
      view.clipsToBounds = true
      return view
   }()

   private let rowImage: UIImageView = {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFill
      imageView.tintColor = .white
      return imageView
   }()
   
   private let rowTitle: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = .systemFont(ofSize: 16, weight: .medium)
      label.textColor = .label
      return label
   }()
   
   private let chevronIndicator: UIImageView = {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.image = UIImage(systemName: "chevron.forward")
      imageView.tintColor = .systemGray2
      return imageView
   }()
   
   
   // MARK: - View Initializations
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      contentView.backgroundColor = .systemGray6.withAlphaComponent(0.8)

      contentView.addSubview(rowImageCona)
      rowImageCona.addSubview(rowImage)
      contentView.addSubview(rowTitle)
      contentView.addSubview(chevronIndicator)
      applyConstraints()
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   
   private func applyConstraints() {
      let constraints = [

         rowImageCona.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         rowImageCona.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
         rowImageCona.widthAnchor.constraint(equalToConstant: 32),
         rowImageCona.heightAnchor.constraint(equalToConstant: 32),
         
         rowImage.centerYAnchor.constraint(equalTo: rowImageCona.centerYAnchor),
         rowImage.centerXAnchor.constraint(equalTo: rowImageCona.centerXAnchor),
         rowImage.widthAnchor.constraint(equalToConstant: 22),
         rowImage.heightAnchor.constraint(equalToConstant: 22),
         
         rowTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         rowTitle.leadingAnchor.constraint(equalTo: rowImageCona.trailingAnchor, constant: 10),
         
         chevronIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         chevronIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
      ]
      
      NSLayoutConstraint.activate(constraints)
   }
   
   
   public func configureUI(model: SectionRowModel) {
      self.rowImageCona.backgroundColor = model.color
      self.rowImage.image = UIImage(systemName: model.image)
      self.rowTitle.text = model.title
   }
}

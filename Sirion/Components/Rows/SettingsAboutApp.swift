//
//  SettingsAboutApp.swift
//  Sirion
//
//  Created by IC Deis on 10/31/23.
//

import UIKit

class SettingsAboutApp: UITableViewCell {
   
   static let ID = "SettingsAboutApp"
   static func nib() -> UINib { UINib(nibName: "SettingsAboutApp", bundle: nil) }
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
      contentView.backgroundColor = .systemGray6.withAlphaComponent(0.8)
      selectionStyle = .none
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
}

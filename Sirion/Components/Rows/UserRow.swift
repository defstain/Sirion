//
//  UserRow.swift
//  Sirion
//
//  Created by IC Deis on 10/23/23.
//

import UIKit
import Kingfisher

class UserRow: UITableViewCell {
   
   static let ID = "UserRow"
   static func nib() -> UINib { UINib(nibName: "UserRow", bundle: nil) }
   
   @IBOutlet var profilePhoto: UIImageView!
   @IBOutlet var displayName: UILabel!
   @IBOutlet var username: UILabel!
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
      separatorInset = .zero
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
   }
   
   func configureUI(user: DBUser) {
      profilePhoto.kf.setImage(with: user.photoUrl?.asURL)
      displayName.text = user.displayName
      username.text = user.username.asUsername()
   }
   
}

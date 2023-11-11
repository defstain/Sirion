//
//  ChatRow.swift
//  Sirion
//
//  Created by IC Deis on 10/29/23.
//

import UIKit
import Kingfisher

class ChatRow: UITableViewCell {
   
   static let ID = "ChatRow"
   static func nib() -> UINib { UINib(nibName: "ChatRow", bundle: nil) }
   
   @IBOutlet var profilePhoto: UIImageView!
   @IBOutlet var displayName: UILabel!
   @IBOutlet var lastMessage: UILabel!
   @IBOutlet var lastMesageDate: UILabel!
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   
   public func configureUI(chat: DBUserChat) {
      displayName.text = chat.displayName
      StorageManager.shared.getProfilePhoto(withUid: chat.chattedUserID) { [weak self] image in
         self?.profilePhoto.image = image
      }
   }
   
}

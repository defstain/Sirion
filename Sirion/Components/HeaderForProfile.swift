//
//  HeaderForProfile.swift
//  Sirion
//
//  Created by IC Deis on 10/28/23.
//

import UIKit
import Kingfisher

class HeaderForProfile: UICollectionReusableView {

   static let ID = "HeaderForProfile"
   static func nib() -> UINib { UINib(nibName: "HeaderForProfile", bundle: nil) }
   
   @IBOutlet var profilePhoto: UIImageView!
   @IBOutlet var displayName: UILabel!
   @IBOutlet var city: UILabel!
   @IBOutlet var joinedDate: UILabel!
   @IBOutlet var username: UILabel!
   @IBOutlet var bio: UILabel!
   @IBOutlet var postsCount: UILabel!
   @IBOutlet var likesCount: UILabel!
   @IBOutlet var followersCount: UILabel!
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   
   public func configureUI(user: DBUser?, posts count: Int, likes: Int, followers: Int) {
      profilePhoto.kf.setImage(with: user?.photoUrl?.asURL)
      displayName.text = user?.displayName
      username.text = user?.username.asUsername()
      bio.text = user?.bio
      joinedDate.text = user?.dateJoined?.asString(.medium).addString("Joined at", side: .left)
      city.text = user?.city
      
      postsCount.text = count.asString()
      likesCount.text = likes.asString()
      followersCount.text = followers.asString()
   }
   
   
}

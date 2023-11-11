//
//  HeaderForUserProfile.swift
//  Sirion
//
//  Created by IC Deis on 10/26/23.
//

import UIKit
import Kingfisher

protocol HeaderForUserProfileDelegate {
   
   func openChatView()
   
}

class HeaderForUserProfile: UICollectionReusableView {

   static let ID = "HeaderForUserProfile"
   static func nib() -> UINib { UINib(nibName: "HeaderForUserProfile", bundle: nil) }
   
   @IBOutlet var profilePhoto: UIImageView!
   @IBOutlet var displayName: UILabel!
   @IBOutlet var city: UILabel!
   @IBOutlet var joinedDate: UILabel!
   @IBOutlet var username: UILabel!
   @IBOutlet var bio: UILabel!
   @IBOutlet var postsCount: UILabel!
   @IBOutlet var likesCount: UILabel!
   @IBOutlet var followersCount: UILabel!
   @IBOutlet var followButton: UIButton!
   
   
   // MARK: - Properties
   public var dbuser: DBUser!
   public var delegate: HeaderForUserProfileDelegate?
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
   }
   
   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }
   
   @IBAction func didTapFollow() {
      guard let mainUID = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         if dbuser.followers.contains(mainUID) {
            try await UserManager.shared.unfollow(me: mainUID, to: dbuser.uid)
            dbuser = dbuser.unfollow(userID: mainUID)
            followButtonConfigure(title: "Follow", color: .white, background: .systemBlue)
            updateMainUserFollowings(userID: dbuser.uid, state: .unfollow)
         } else {
            try await UserManager.shared.follow(me: mainUID, to: dbuser.uid)
            dbuser = dbuser.follow(userID: mainUID)
            followButtonConfigure(title: "Unfollow", color: .systemBlue, background: .white)
            updateMainUserFollowings(userID: dbuser.uid, state: .follow)
         }
      }
   }
   
   @IBAction func didTapMessage() {
      delegate?.openChatView()
   }
   
   
   
   
}


extension HeaderForUserProfile {
   
   public func configureUI(posts count: Int, likes: Int, followers: Int) {
      profilePhoto.kf.setImage(with: dbuser?.photoUrl?.asURL)
      displayName.text = dbuser.displayName
      username.text = dbuser.username.asUsername()
      bio.text = dbuser.bio
      joinedDate.text = dbuser.dateJoined?.asString(.medium).addString("Joined at", side: .left)
      city.text = dbuser.city
      
      postsCount.text = count.asString()
      likesCount.text = likes.asString()
      followersCount.text = followers.asString()
      
      if let mainUserFollowings = UserDefaults.standard.array(forKey: UDKeys.followings) as? [String] {
         if mainUserFollowings.contains(dbuser.uid) {
            followButtonConfigure(title: "Unfollow", color: .systemBlue, background: .white)
         }
      }
   }
   
   private func followButtonConfigure(title: String, color: UIColor, background: UIColor) {
      followButton.setTitle(title, for: .normal)
      followButton.setTitleColor(color, for: .normal)
      followButton.backgroundColor = background
   }
   
   private func updateMainUserFollowings(userID: String, state: FollowState) {
      let mainUserFollowings = (UserDefaults.standard.array(forKey: UDKeys.followings) as? [String]) ?? []
      if state == .follow {
         let newArray = mainUserFollowings + [userID]
         UserDefaults.standard.set(newArray, forKey: UDKeys.followings)
      } else {
         let newArray = mainUserFollowings.filter { $0 != userID }
         UserDefaults.standard.set(newArray, forKey: UDKeys.followings)
      }
   }
   
   enum FollowState {
      case follow
      case unfollow
   }
   
}

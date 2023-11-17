//
//  UserModel.swift
//  Sirion
//
//  Created by IC Deis on 6/22/23.
//

import Foundation
import Firebase

struct DBUser: Codable {
   let uid: String
   let username: String
   let displayName: String
   let email: String
   let bio: String?
   let city: String?
   let photoPath: String?
   let photoUrl: String?
   let provider: String?
   let followers: [String]
   let followings: [String]
   let dateJoined: Date?
   
   enum CodingKeys: String, CodingKey {
      case uid
      case username
      case displayName = "display_name"
      case email
      case bio
      case city
      case photoPath = "photo_path"
      case photoUrl = "photo_url"
      case provider
      case followers
      case followings
      case dateJoined = "date_joined"
   }
   
   func follow(userID: String) -> DBUser {
      return DBUser(uid: uid, username: username, displayName: displayName, email: email, bio: bio, city: city, photoPath: photoPath, photoUrl: photoUrl, provider: provider, followers: followers + [userID], followings: followings, dateJoined: dateJoined)
   }
   func unfollow(userID: String) -> DBUser {
      return DBUser(uid: uid, username: username, displayName: displayName, email: email, bio: bio, city: city, photoPath: photoPath, photoUrl: photoUrl, provider: provider, followers: followers.filter { $0 != userID}, followings: followings, dateJoined: dateJoined)
   }
}

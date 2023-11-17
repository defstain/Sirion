//
//  DBFields.swift
//  Sirion
//
//  Created by IC Deis on 6/22/23.
//

import Foundation

/// Constants for Database User
struct DBUserFields {
   
   static let uid = "uid"
   static let username = "username"
   static let displayName = "display_name"
   static let email = "email"
   static let bio = "bio"
   static let city = "city"
   static let photoPath = "photo_path"
   static let photoUrl = "photo_url"
   static let provider = "provider"
   static let followers = "followers"
   static let followings = "followings"
   static let dateJoined = "date_joined"
   static let profilePhoto = "profile_photo"
}

/// Constants for  Database Comment fields
struct CommentFields {
   
   static let commentID = "commment_id"
   static let userID = "user_id"
   static let displayName = "displayName"
   static let content = "content"
   static let dateAdded = "date_added"
   
}

/// UserDefaults constants for Lock Screen
struct PassKeys {
   
   static let passTimeRequirement = "password_time_requirement"
   static let showLockScreen = "show_lock_screen"
   static let currentpass = "current_pass"
   static let useBiometric = "user_biometric"
   
}

/// UserDefaults constants for user
struct UDKeys {
   
   static let uid = "user_id"
   static let username = "user_username"
   static let displayName = "user_displayName"
   static let bio = "user_bio"
   static let photo = "user_profile_photo"
   static let photoUrl = "user_profile_photo_url"
   static let dbuser = "dbuser"
   static let followings = "user_followings"
   
}

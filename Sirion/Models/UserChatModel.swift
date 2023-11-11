//
//  UserChatModel.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import Foundation

struct DBUserChat: Codable {
   let id: String
   let chatID: String
   let chattedUserID: String
   let displayName: String
   
   enum CodingKeys: String, CodingKey {
      case id
      case chatID = "chat_id"
      case chattedUserID = "chatted_user_id"
      case displayName = "display_name"
   }
}

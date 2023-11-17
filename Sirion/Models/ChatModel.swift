//
//  ChatModel.swift
//  Sirion
//
//  Created by IC Deis on 7/24/23.
//

import Foundation
import FirebaseFirestoreSwift

struct DBChat: Codable {
   let chatID: String
   let dateAdded: Date

   enum CodingKeys: String, CodingKey {
      case chatID = "chat_id"
      case dateAdded = "date_added"
   }
}

struct Bubble: Codable, Equatable {
   @DocumentID var id: String?
   let uid: String
   let message: String
   let dateSent: Date
   
   enum CodingKeys: String, CodingKey {
      case id
      case uid
      case message
      case dateSent = "date_sent"
   }
}

//
//  CommentModel.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import Foundation

struct Comment: Identifiable, Hashable, Codable {
   var id = UUID().uuidString
   let commentID: String
   let userID: String
   let username: String
   let content: String
   let dateAdded: Date
   
   enum CodingKeys: String, CodingKey {
      case commentID = "commment_id"
      case userID = "user_id"
      case username
      case content
      case dateAdded = "date_added"
   }
   
   func hash(into hasher: inout Hasher) {
      hasher.combine(id)
   }
}

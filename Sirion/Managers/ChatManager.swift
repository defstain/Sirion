//
//  ChatManager.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import Foundation
//import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
class ChatManager {
   
   static let shared = ChatManager()
   private init() { }
   
   // MARK: -- Chat References
   private let chatCollection = Firestore.firestore().collection("chats")
   private func chatDocument(chatID: String) -> DocumentReference { chatCollection.document(chatID) }
   private func bubblesCollection(chatID: String) -> CollectionReference { chatDocument(chatID: chatID).collection("bubbles")}
   private var chatListener: ListenerRegistration? = nil
   private var bubblesArray = [Bubble]()
   
   
   // MARK: -- Write and Read Functions
   func getChats() async throws -> [DBUserChat] {
      return try await chatCollection.getDocuments(as: DBUserChat.self)
   }
    
   func openNewChat(bubble: Bubble) async throws -> String {
      let document = chatCollection.document()
      let newChat = DBChat(chatID: document.documentID, dateAdded: Date())
      
      try chatDocument(chatID: document.documentID).setData(from: newChat, merge: true)
      try await sendMessage(chatID: document.documentID, bubble: bubble)
      
      return document.documentID
   }
   
   func sendMessage(chatID: String, bubble: Bubble) async throws {
      try bubblesCollection(chatID: chatID).addDocument(from: bubble)
   }
   
   
}


// MARK: -- Listeners
extension ChatManager {
   
   func addListenerForPosts(completion: @escaping(_ data: [DBChat]) -> Void) {
      self.chatListener = chatCollection
         .order(by: "date_added", descending: true)
         .addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let posts = documents.compactMap { try? $0.data(as: DBChat.self) }
            completion(posts)
         }
   }
   
   func addListenerForBubbles(chatID: String, completion: @escaping (_ data: [Bubble], _ changed: Bool) -> Void) {
      self.chatListener = bubblesCollection(chatID: chatID)
         .order(by: "date_sent", descending: false)
         .addSnapshotListener{ snapshot, error in
            if let error {
               print("DEBUG: Error listening bubbles collection. - \(error)")
               return
            }
            guard let documents = snapshot?.documents else { return }
            let bubbles = documents.compactMap { try? $0.data(as: Bubble.self)}
            
            if self.bubblesArray.count == bubbles.count && !self.bubblesArray.isEmpty {
               completion(bubbles, false)
            } else {
               self.bubblesArray = bubbles
               completion(bubbles, true)
            }
         }
   }
   
}

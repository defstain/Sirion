//
//  ChatVM.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import Foundation

@MainActor
final class ChatVM: ObservableObject {
   @Published var bubbles: [Bubble] = []
   @Published var messageInput: String = ""
   @Published var chatID: String? {
      didSet { getBubbles() }
   }
   
   private let userManager = UserManager.shared
   private let chatManager = ChatManager.shared
   
   
   init(chatID: String?) {
      self.chatID = chatID
   }
   
   init() { }
   
   
   func getBubbles() {
      guard let chatID else { return }
      guard let _ = mainUserID else { return }
      chatManager.addListenerForBubbles(chatID: chatID) { bubbles, changed in
         if changed {
            NotificationManager.shared.askPermission()
            NotificationManager.shared.scheduleNotification(title: "New message", subtitle: "You have new message", count: 2 )
         }
         self.bubbles = bubbles
      }
   }
   
   
   
   func sendNewMessage(chatID: String) {
      guard !messageInput.isEmpty else { return }
      guard let mainUID = mainUserID else { return }

      Task {
         let bubble = Bubble(uid: mainUID, message: messageInput, dateSent: Date())
         try await chatManager.sendMessage(chatID: chatID, bubble: bubble)
         messageInput = ""
      }
   }
   
   func startMessaging(chattedUserID: String, chattedUserDisplayName: String) {
      guard !messageInput.isEmpty,
            let displayName = UserDefaults.standard.string(forKey: UDKeys.displayName),
            let mainUID = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      
      Task {
         let bubble = Bubble(uid: mainUID, message: messageInput, dateSent: Date())
         let chatID = try await chatManager.openNewChat(bubble: bubble)

         try await userManager.addNewChat(chatID: chatID, uid: mainUID, displayName: displayName, chattedUserID: chattedUserID, chattedUserDisplayName: chattedUserDisplayName, lastMessage: bubble.message, dateSent: bubble.dateSent)
         self.chatID = chatID
         getBubbles()
         messageInput = ""
      }
   }
   
}

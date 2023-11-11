//
//  ChatsVM.swift
//  InstaDC
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

@MainActor
final class ChatsVM: ObservableObject {
   @Published var chatsArray: [DBUserChat] = []
   @Published var infoMessage: LocalizedStringKey = ""
   
   private let userManager = UserManager.shared
   
   init() {
      getAllChats()
   }
   
   func getAllChats() {
      guard chatsArray.isEmpty else { return }
      guard let mainUid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         self.chatsArray = try await userManager.getChats(uid: mainUid)
         if chatsArray.isEmpty {
            infoMessage = "No messages"
         } else {            
            infoMessage = ""
         }
      }
   }
   
   
}

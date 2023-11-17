//
//  ChatView.swift
//  Sirion
//
//  Created by IC Deis on 7/24/23.
//

import SwiftUI

struct ChatView: View {
//   @EnvironmentObject private var chatsVM: ChatsVM
   @StateObject private var vm = ChatVM()
   
   @State var chatID: String?
   let chattedUserID: String
   let displayName: String
   let updateChats: () -> Void
   
   @AppStorage(UDKeys.uid) private var currentUserID = ""
   
   
   var body: some View {
      VStack {
         ScrollView {
            topChatInfo
            ForEach(vm.bubbles, id: \.id) { bubble in
               if bubble.uid == currentUserID {
                  MyMessageRow(message: bubble.message)
               } else {
                  UserMessageRow(message: bubble.message)
               }
            }
            
         }
         .padding(.horizontal, 10)
         .frame(maxWidth: .infinity)
         
         HStack {
            TextField("Type here...", text: $vm.messageInput)
               .autocorrectionDisabled()
               .submitLabel(.done)
            
            Button {
               if let id = vm.chatID {
                  vm.sendNewMessage(chatID: id)
               } else {
                  vm.startMessaging(chattedUserID: chattedUserID, chattedUserDisplayName: displayName)
                  updateChats()
               }
            } label: {
               Text("Send")
                  .font(.headline)
                  .foregroundColor(.blue)
            }
            
         }
         .padding(12)
         .background(.ultraThinMaterial)
         .cornerRadius(10)
         .padding(.horizontal)
         .onAppear {
            if let chatID {
               vm.chatID = chatID
            } else {
               Task {
                  let chat = try await UserManager.shared.getChat(uid: currentUserID, chattedUserID: chattedUserID)
                  vm.chatID = chat?.chatID
               }
            }
         }
         .padding(.bottom, 10)
      }
      .navigationTitle(displayName)
      .navigationBarTitleDisplayMode(.inline)
   }
}


extension ChatView {
   
   private var topChatInfo: some View {
      VStack {
         ProfilePhoto(userID: chattedUserID)
            .frame(width: 90, height: 90)
         Text(displayName)
            .font(.title3)
            .bold()
            .foregroundColor(.primary)
            .font(.footnote)
            .foregroundColor(.gray)
      }
      .padding(.bottom)
   }
   
}

//struct ChatView_Previews: PreviewProvider {
//   static var previews: some View {
//      NavigationView {
//         ChatView(chatID: "gfhjsd", userID: "fdkjfb", displayName: "DEVISS DC", action: { })
//      }
//      .environmentObject(ChatsVM())
//   }
//}

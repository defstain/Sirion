//
//  CommentsVM.swift
//  InstaDC
//
//  Created by IC Deis on 6/27/23.
//

import SwiftUI

@MainActor
final class CommentsVM: ObservableObject {
   @Published var user: DBUser? = nil
   
   @Published var comments: [Comment] = []
   @Published var content: String = ""
   @Published var isLoading: Bool = false
   
   @Published var showAlert: Bool = false
   @Published var alertTitle: String = ""
   @Published var alertMessage: String = ""
   
   private let postID: String
   private let haptics = UINotificationFeedbackGenerator()
   private let postManager = PostManager.shared
   
   init(postID: String) {
      self.postID = postID
      self.user = getFromUserDefaults(as: DBUser.self, key: UDKeys.dbuser)
      getCommentsWithListener()
   }
   
   
   func getCommentsWithListener() {
      postManager.addListenerForComments(postID: postID) { data in
         self.comments = data
      }
   }
   
   func uploadComment() {
      guard let user = user, content.count > 3 else { return }
      guard isAppropriate(comment: content) else { return }
      
      let newComment = Comment(commentID: UUID().uuidString, userID: user.uid, username: user.displayName, content: content, dateAdded: Date())
      isLoading = true
      do {
         try postManager.uploadComment(postID: postID, comment: newComment)
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.content = ""
            self.isLoading = false
         }
         UIApplication.shared.dismissKeyboard()
      } catch {
         isLoading = false
         alertTitle = "Error!"
         alertMessage = "Could not upload your comment."
         showAlert.toggle()
      }
      
      func isAppropriate(comment: String) -> Bool {
         let curses: [String] = ["ass", "anal", "fuck", "dick", "cock", "pussy", "shit", "porn", "boob", "boobs"]
         let words = comment.components(separatedBy: " ")
         
         for word in words {
            if curses.contains(word.lowercased()) {
               haptics.notificationOccurred(.warning)
               return false
            }
         }
         return true
      }
   }
   
}

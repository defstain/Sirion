//
//  CommentView.swift
//  Sirion
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct CommentView: View {
   let comment: Comment
   
   var body: some View {
      HStack(alignment: .top, spacing: 10) {
         
         // MARK: - User profile image
         ProfilePhoto(userID: comment.userID)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
         
         VStack(alignment: .leading, spacing: 5) {
            
            // MARK: - User username
            Text(comment.username)
               .font(.subheadline)
               .foregroundColor(.gray)
            
            // MARK: - Comment content
            Text(comment.content)
               .padding(8)
               .background(Color.gray.opacity(0.3))
               .cornerRadius(6)
         }
         
         Spacer()
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 8)
   }
}

struct CommentView_Previews: PreviewProvider {
   static var comment1 = Comment(commentID: "508", userID: "509", username: "Platinium S", content: "Test comment for this view", dateAdded: Date())
   
   static var previews: some View {
      CommentView(comment: comment1)
   }
}

//
//  CommentsView.swift
//  InstaDC
//
//  Created by IC Deis on 6/13/23.
//

import SwiftUI

struct CommentsView: View {
   @StateObject private var vm: CommentsVM
   let postID: String

   
   init(postID: String) {
      self.postID = postID
      _vm = StateObject(wrappedValue: CommentsVM(postID: postID))
   }
   
   var body: some View {
      VStack(alignment: .leading) {
         
         ScrollView {
            LazyVStack(spacing: 5) {
               ForEach(vm.comments) { comment in
                  CommentView(comment: comment)
               }
            }
            .padding(.top, 8)
         }
         
         HStack(spacing: 5) {
            ProfilePhoto(userID: vm.user?.uid ?? "")
               .frame(width: 40, height: 40)
               .clipShape(Circle())
            
            HStack {
               TextField("Type here...", text: $vm.content)
                  .autocorrectionDisabled()
                  .submitLabel(.done)
               
               Button {
                  vm.uploadComment()
               } label: {
                  Text("Send")
                     .font(.headline)
                     .foregroundColor(.blue)
               }
               .opacity(vm.isLoading ? 0.1 : 1.0)
               .disabled(vm.isLoading)
            }
            .padding(10)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
         }
         .padding(10)
      }
      .navigationTitle("Comments")
      .navigationBarTitleDisplayMode(.inline)
      .alert(vm.alertTitle, isPresented: $vm.showAlert, actions: { }) {
         Text(vm.alertMessage)
      }
   }
}


struct ProfilePhoto: View {
   @State private var image: UIImage?
   let userID: String
   
    var body: some View {
       ZStack {
          if let uiimage = image {
             Image(uiImage: uiimage)
                .resizable()
                .scaledToFill()
          } else {
             Circle()
                .fill(.ultraThinMaterial)
          }
       }
       .clipShape(Circle())
       .task {
          StorageManager.shared.getProfilePhoto(withUid: userID) { image in
             self.image = image
          }
       }
    }
}


struct CommentsView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationView {
         CommentsView(postID: "I9zGOcz3Zo8IOo1iNiyy")
      }
   }
}

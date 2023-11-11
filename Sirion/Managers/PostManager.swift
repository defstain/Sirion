//
//  PostManager.swift
//  InstaDC
//
//  Created by IC Deis on 6/24/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Post Manager class
/// Class manages all post related actions in the database
final class PostManager {
   
   static let shared = PostManager()
   private init() { }
   
   private var postListener: ListenerRegistration? = nil
   private var commentsListener: ListenerRegistration? = nil
   private let postsCollection = Firestore.firestore().collection("posts")
   private let reportCollection = Firestore.firestore().collection("reports")
   private func postDocuments(postID: String) -> DocumentReference { postsCollection.document(postID) }
   private func commentsCollection(postID: String) -> CollectionReference { postDocuments(postID: postID).collection("comments") }
   
   /// Upload new post to the database
   func uploadPost(uid: String, username: String, caption: String, imageUrl: String) throws {
      let postID = postsCollection.document().documentID
      let newPost = Post(postID: postID, userID: uid, username: username, caption: caption,
                         dateAdded: Date(), likes: [], imageURL: imageUrl)
      try postDocuments(postID: postID).setData(from: newPost)
   }
   
   /// Returns the post by the given post id
   func getPost(postID: String) async throws -> Post {
      return try await postDocuments(postID: postID).getDocument(as: Post.self)
   }
   
   /// Returns all posts
   func getAllPosts() async throws -> [Post] {
      do {
         return try await postsCollection
            .order(by: "date_added", descending: true)
            .limit(to: 20)
            .getDocuments(as: Post.self)
      } catch {
         print("DEF: getAllPosts - \(error.localizedDescription)")
         return []
      }
   }
   
   /// Returns the posts uploaded by the current user
   func getMyPosts(uid: String) async throws -> [Post] {
      return try await postsCollection
         .whereField("user_id", isEqualTo: uid)
         .getDocuments(as: Post.self)
         .sorted { $0.dateAdded > $1.dateAdded}
   }
   
   /// Updates post username
   func updatePostUsername(postID: String, username: String) async throws {
      try await postDocuments(postID: postID).updateData(["username": username])
   }
   
   /// Deletes post from the database by given id
   func deletePost(postID: String) async throws {
      try await postDocuments(postID: postID).delete()
   }
   
   /// Likes post
   func likePost(postID: String, userID: String) async throws {
      let data: [String: Any] = ["likes": FieldValue.arrayUnion([userID])]
      try await postDocuments(postID: postID).updateData(data)
   }
   
   /// Unlikes post
   func unlikePost(postID: String, userID: String) async throws {
      let data: [String: Any] = ["likes": FieldValue.arrayRemove([userID])]
      try await postDocuments(postID: postID).updateData(data)
   }
   
   /// Report post to the admins
   func reportPost(reason: String, postID: String) async throws -> Bool {
      let data: [String: Any] = ["reason": reason, "post_id": postID, "date_reported": Date()]
      do {
         try await reportCollection.document(postID).setData(data)
         return true
      } catch {
         return false
      }
   }
   
   func getCommentsCount(postID: String) async throws -> Int {
      let query = commentsCollection(postID: postID)
      let countQuery = query.count
      do {
          let snapshot = try await countQuery.getAggregation(source: .server)
         return snapshot.count.intValue
      } catch {
         printConsole(type: .error, error.localizedDescription)
         return 0
      }
   }
   
}


// MARK: -- Comments Section
extension PostManager {
   
   /// Uploads comment to the post
   func uploadComment(postID: String, comment: Comment) throws {
      try commentsCollection(postID: postID).addDocument(from: comment)
   }
   
}

// MARK: -- Listeners
extension PostManager {
   
   /// Add listener for posts
   func addListenerForPosts(completion: @escaping(_ data: [Post]) -> Void) {
      self.postListener = postsCollection
         .order(by: "date_added", descending: true)
         .addSnapshotListener { snapshot, error in
         guard let documents = snapshot?.documents else { return }
         let posts = documents.compactMap { try? $0.data(as: Post.self) }
         completion(posts)
      }
   }
   
   /// Add listener for comments
   func addListenerForComments(postID: String, completion: @escaping (_ data: [Comment]) -> Void) {
      self.commentsListener = commentsCollection(postID: postID)
         .order(by: CommentFields.dateAdded, descending: false)
         .addSnapshotListener{ snapshot, error in
            if let error {
               printConsole(type: .error, "Failed to listening comments collection - \(error.localizedDescription)")
               return
            }
            guard let documents = snapshot?.documents else { return }
            let comments = documents.compactMap { try? $0.data(as: Comment.self)}
            completion(comments)
         }
   }
}

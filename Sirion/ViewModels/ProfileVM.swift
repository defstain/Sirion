//
//  ProfileVM.swift
//  Sirion
//
//  Created by IC Deis on 10/25/23.
//

import Foundation

class ProfileVM: ObservableObject {
   @Published var postsArray = [Post]()
   
   private let userManager = UserManager.shared
   private let postManager = PostManager.shared
   
   init() { }
   
   
   func getUser(uid: String) async throws -> DBUser {
      return try await userManager.getUser(withUId: uid)
   }
   
   func getPosts(uid: String) async throws -> [Post] {
      return try await postManager.getMyPosts(uid: uid)
   }
}

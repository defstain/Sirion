//
//  HomeVM.swift
//  Sirion
//
//  Created by IC Deis on 10/25/23.
//

import Foundation
import Combine

class HomeVM: ObservableObject {
   @Published var postsArray = [Post]()
   
   init() {
      getPosts()
   }
   
   func getPosts() {
      PostManager.shared.addListenerForPosts { [weak self] data in
         self?.postsArray = data
      }
   }
   
}

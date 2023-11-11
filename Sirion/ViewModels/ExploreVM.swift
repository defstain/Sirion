//
//  ExploreVM.swift
//  Sirion
//
//  Created by IC Deis on 10/23/23.
//

import Foundation
import Combine

class ExploreVM: ObservableObject {
   @Published var searchBarText: String = ""
   @Published var postsArray = [Post]()
   
   init() { }
   

}

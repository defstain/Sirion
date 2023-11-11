//
//  CommentsVC.swift
//  Sirion
//
//  Created by IC Deis on 10/19/23.
//

import UIKit
import SwiftUI

class CommentsVC: UIViewController {
   
   public var postID: String!
   private var commentsView: UIHostingController<CommentsView>!
   
   
//    MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      view.backgroundColor = .systemBackground
      title = "Comments"
      
      let hostView = UIHostingController(rootView: CommentsView(postID: postID))
      commentsView = hostView
      view.addSubview(commentsView.view)
      applyConstraints()
   }
   
   
   func applyConstraints() {
      guard let comments = commentsView.view else { return }
      comments.translatesAutoresizingMaskIntoConstraints = false
      let constraints = [
         comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         comments.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         comments.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      ]
      
      NSLayoutConstraint.activate(constraints)
   }

}

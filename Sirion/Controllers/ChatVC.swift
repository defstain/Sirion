//
//  ChatVC.swift
//  Sirion
//
//  Created by IC Deis on 10/29/23.
//

import UIKit
import SwiftUI

protocol ChatDelegate {
   
   func getAllChats()
   
}

class ChatVC: UIViewController {

   // MARK: - Properties
   public var chatID: String?
   public var chattedUserID: String!
   public var displayName: String!
   public var profilPhot: UIImage!
   
   var chatView: UIHostingController<ChatView>!
   var delegate: ChatDelegate?
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      navigationItem.backButtonDisplayMode = .minimal
      title = displayName
      
      let hostView = UIHostingController(rootView: ChatView(chatID: chatID, chattedUserID: chattedUserID, displayName: displayName, updateChats: {
         self.delegate?.getAllChats()
      }))
      chatView = hostView
      
      view.addSubview(chatView.view)
      applyConstraints()
   }
   
   
   func applyConstraints() {
      guard let chat = chatView.view else { return }
      chat.translatesAutoresizingMaskIntoConstraints = false
      let constraints = [
         chat.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         chat.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         chat.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         chat.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      ]
      
      NSLayoutConstraint.activate(constraints)
   }

}

//
//  MessagesVC.swift
//  Sirion
//
//  Created by IC Deis on 10/26/23.
//

import UIKit
import Combine

class MessagesVC: UIViewController {

   @IBOutlet var tableView: UITableView!
   
   
   // MARK: - Properties
   private let chatsVM = ChatsVM()
   private let userManager = UserManager.shared
   private var chatsArray = [DBUserChat]()
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.register(ChatRow.nib(), forCellReuseIdentifier: ChatRow.ID)
      getChats()
   }

   
   @IBAction func didTapClose() {
      dismiss(animated: true)
   }
   
   
   private func getChats() {
      guard let uid = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      Task {
         let chats = try await userManager.getChats(uid: uid)
         self.chatsArray = chats
         tableView.reloadData()
      }
   }
   
}


extension MessagesVC: UITableViewDelegate, UITableViewDataSource, ChatDelegate {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return chatsArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: ChatRow.ID, for: indexPath) as! ChatRow
      let chat = chatsArray[indexPath.row]
      cell.configureUI(chat: chat)
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      let chat = chatsArray[indexPath.row]
      let chatVC = ChatVC.instantiate()
      chatVC.delegate = self
      chatVC.chatID = chat.chatID
      chatVC.displayName = chat.displayName
      chatVC.chattedUserID = chat.chattedUserID
      navigationController?.show(chatVC, sender: self)
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 75
   }
   
   func getAllChats() {
      getChats()
      tableView.reloadData()
   }
   
}

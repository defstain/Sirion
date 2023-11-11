//
//  HomeVC.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit
import Combine

class HomeVC: UIViewController {

   @IBOutlet var tableView: UITableView!
   private let refreshControl = UIRefreshControl()
   
   // MARK: - Properties
   private let vm = HomeVM()
   private let userManager = UserManager.shared
   private let postManager = PostManager.shared
   private var cancellables = Set<AnyCancellable>()
   
   private var postsArray = [Post]()
   private var userID: String = ""

   // MARK: - View Lifesycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      tableView.register(PostRow.nib(), forCellReuseIdentifier: PostRow.ID)
      tableView.separatorInset = UIEdgeInsets.zero
      tableView.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(didPullDown), for: .valueChanged)

      addSubscribers()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      userID = mainUserID ?? ""
   }
   
   
   
   private func addSubscribers() {
      vm.$postsArray
         .sink { [weak self] posts in
            self?.postsArray = posts
            self?.tableView.reloadData()
         }
         .store(in: &cancellables)
   }
   
   @objc private func didPullDown() {
      Task {
         try await SetMainUserData()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
         self.refreshControl.endRefreshing()
      }
   }
   
}


// MARK: - TableView and Cell Methods
extension HomeVC: UITableViewDelegate, UITableViewDataSource, PostRowDelegate {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return postsArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: PostRow.ID, for: indexPath) as! PostRow
      let post = postsArray[indexPath.row]
      cell.configureUI(post: post)
      cell.delegate = self
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
   
   func showActionSheet(post: Post) {
      let controller = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
      let editAC = UIAlertAction(title: "Edit", style: .default)
      let shareAC = UIAlertAction(title: "Share", style: .default)
      let learnMoreAC = UIAlertAction(title: "Learn more", style: .default)
      let reportAC = UIAlertAction(title: "Report", style: .destructive)
      let deleteAC = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
         self?.showDeletePostConfirmation(postID: post.postID)
      }
      let cancelAC = UIAlertAction(title: "Cancel", style: .cancel)
      
      if userID == post.userID { controller.addAction(editAC) }
      controller.addAction(shareAC)
      controller.addAction(learnMoreAC)
      controller.addAction(reportAC)
      if userID == post.userID { controller.addAction(deleteAC) }
      controller.addAction(cancelAC)
      
      present(controller, animated: true)
   }
   
   func gotoProfile(userID: String, postUser: DBUser, displayName: String) {
      if self.userID == userID {
         tabBarController?.selectedIndex = 4
      } else {
         let vc = storyboard?.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
         vc.userID = userID
         vc.dbuser = postUser
         vc.displayName = displayName
         navigationController?.pushViewController(vc, animated: true)
      }
   }
   
   func likeToPost(post: Post) {
      Task {
         if post.likes.contains(userID) {
            try await postManager.unlikePost(postID: post.postID, userID: userID)
         } else {
            try await postManager.likePost(postID: post.postID, userID: userID)
         }
      }
   }
   
   func gotoCommentView(postID: String) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
      vc.postID = postID
      navigationController?.pushViewController(vc, animated: true)
   }
   
}




extension HomeVC {
   
   private func showDeletePostConfirmation(postID: String) {
      let ac = UIAlertController(title: "Are you sure want to delete this post?", message: nil, preferredStyle: .actionSheet)
      let deleteAC = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
         Task {
            try await self?.postManager.deletePost(postID: postID)
         }
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel)
      ac.addAction(deleteAC)
      ac.addAction(cancel)
      present(ac, animated: true)
   }
   
}

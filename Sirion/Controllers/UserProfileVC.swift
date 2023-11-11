//
//  UserProfileVC.swift
//  Sirion
//
//  Created by IC Deis on 10/18/23.
//

import UIKit

class UserProfileVC: UIViewController {
   
   @IBOutlet var collectionView: UICollectionView!
   
   
   // MARK: - Properties and Lifecycles
   public var dbuser: DBUser!
   public var userID: String!
   public var displayName: String!
   
   private let vm = ProfileVM()
   private var postsArray = [Post]()
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      title = "Profile"
      
      setupCollectionView()
      getProfileData()
      getPosts()
   }
   
   
   private func setupCollectionView() {
      collectionView.register(PostImageCell.nib(), forCellWithReuseIdentifier: PostImageCell.ID)
      collectionView.register(HeaderForUserProfile.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForUserProfile.ID)
   }
   private func getProfileData() {
      Task {
         self.dbuser = try await vm.getUser(uid: userID)
         self.postsArray = try await vm.getPosts(uid: userID)
         collectionView.reloadData()
      }
   }
   private func getPosts() {
      Task {
         self.postsArray = try await PostManager.shared.getMyPosts(uid: userID)
         collectionView.reloadData()
      }
   }
   

}


extension UserProfileVC: HeaderForUserProfileDelegate {
   
   func openChatView() {
      let chatView = ChatVC.instantiate()
      chatView.chattedUserID = userID
      chatView.displayName = displayName
      navigationController?.show(chatView, sender: self)
   }
   
}


extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return postsArray.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCell.ID, for: indexPath) as! PostImageCell
      let post = postsArray[indexPath.row]
      cell.postImage.kf.setImage(with: post.imageURL.asURL)
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let size = (view.width / 3) - 2
      return CGSize(width: size, height: size)
   }
   
   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderForUserProfile.ID, for: indexPath) as! HeaderForUserProfile
      let likes = postsArray.compactMap { $0.likes.count }.reduce(0, +)
      header.dbuser = dbuser
      header.configureUI(posts: postsArray.count, likes: likes, followers: dbuser?.followers.count ?? 0)
      header.delegate = self
      return header
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: view.width, height: 300)
   }
   
}

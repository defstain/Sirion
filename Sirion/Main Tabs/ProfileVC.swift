//
//  ProfileVC.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit
import Kingfisher

protocol ProfileDelegate {
   func userSignedOut()
}

class ProfileVC: UIViewController, SettingsDelegate {

   @IBOutlet var collectionView: UICollectionView!
   private let refreshControl = UIRefreshControl()
   
   
   // MARK: - Properties
   public var delegate: ProfileDelegate?
   public var dbuser: DBUser?
   
   private let vm = ProfileVM()
   private var postsArray = [Post]()
   private var profilePhoto: UIImage?
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
            
      setupCollectionView()
      getProfileData()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "SettingsSegue" {
         let navController = segue.destination as! UINavigationController
         let settingVC = navController.topViewController as! SettingsVC
         settingVC.profilePhoto = profilePhoto
         settingVC.delegate = self
      }
   }
   
   
   private func setupCollectionView() {
      collectionView.register(PostImageCell.nib(), forCellWithReuseIdentifier: PostImageCell.ID)
      collectionView.register(HeaderForProfile.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderForProfile.ID)
      collectionView.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(didPullDown), for: .valueChanged)
   }
   
   private func getProfileData() {
      guard let uid = mainUserID else { return }
      let user = getFromUserDefaults(as: DBUser.self, key: UDKeys.dbuser)
      self.dbuser = user
      Task {
         self.postsArray = try await vm.getPosts(uid: uid)
         collectionView.reloadData()
//         guard let imageUrl = dbuser?.photoUrl else { return }
//         self.profilePhoto = try await StorageManager.shared.getImage(withUrl: imageUrl)
         let image = getImageFromUserDefaults(key: UDKeys.photo)
         self.profilePhoto = image
      }
   }

   func signOut() {
      delegate?.userSignedOut()
   }
   
   @objc private func didPullDown() {
      Task {
         try await SetMainUserData()
         getProfileData()
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
         self.refreshControl.endRefreshing()
      }
   }
   
}


extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
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
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderForProfile.ID, for: indexPath) as! HeaderForProfile
      let likes = postsArray.compactMap { $0.likes.count }.reduce(0, +)
      if let profilePhoto {
         header.profilePhoto.image = profilePhoto
      } else {
         header.profilePhoto.kf.setImage(with: dbuser?.photoUrl?.asURL)
      }
      header.configureUI(user: dbuser, posts: postsArray.count, likes: likes, followers: dbuser?.followers.count ?? 0)
      return header
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize(width: view.width, height: 260)
   }
   
}

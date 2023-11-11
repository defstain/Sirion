//
//  PostRow.swift
//  Sirion
//
//  Created by IC Deis on 10/18/23.
//

import UIKit
import Kingfisher

protocol PostRowDelegate: AnyObject {
   func showActionSheet(post: Post)
   func gotoProfile(userID: String, postUser: DBUser, displayName: String)
   func likeToPost(post: Post)
   func gotoCommentView(postID: String)
}

class PostRow: UITableViewCell {

   static let ID = "PostRow"
   static func nib() -> UINib { UINib(nibName: "PostRow", bundle: nil) }
   
   @IBOutlet var profilePhoto: UIImageView!
   @IBOutlet var username: UILabel!
   @IBOutlet var tripleDots: UIButton!
   @IBOutlet var postImage: UIImageView!
   @IBOutlet var likeButton: UIButton!
   @IBOutlet var commentButton: UIButton!
   @IBOutlet var shareButton: UIButton!
   @IBOutlet var postedAt: UILabel!
   @IBOutlet var likesCount: UILabel!
   @IBOutlet var commentsCount: UILabel!
   @IBOutlet var textContent: UILabel!
      
   private var postUser: DBUser?
   public var post: Post!
   weak var delegate: PostRowDelegate?
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
            
      profilePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUserInfo)))
      username.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapUserInfo)))
      getProfileData()
   }

   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      
      profilePhoto.image = nil
      username.text = nil
      postImage.image = nil
      likesCount.text = nil
      commentsCount.text = nil
      textContent.text = nil
   }
   
   
   private func getProfileData() {
      Task {
         self.postUser = try await UserManager.shared.getUser(withUId: post.userID)
      }
   }
   
   public func configureUI(post: Post) {
      self.post = post
      username.text = post.username
      postImage.kf.setImage(with: post.imageURL.asURL)
      postedAt.text = post.dateAdded.asString(.medium)
      likesCount.text = post.likes.count.asString() + " likes"
      textContent.text = post.caption
      
      checkIfUserLikedPost()
      Task {
         let value = try await PostManager.shared.getCommentsCount(postID: post.postID)
         self.commentsCount.text = value.asString().addString("comments", side: .right)
      }
      StorageManager.shared.getProfilePhoto(withUid: post.userID) { [weak self] image in
         self?.profilePhoto.image = image
      }
   }
   
   
   private func checkIfUserLikedPost() {
      guard let userID = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      if post.likes.contains(userID) {
         likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
         likeButton.configuration?.baseForegroundColor = .red
      } else {
         likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
         likeButton.configuration?.baseForegroundColor = .label
      }
   }
   
}


extension PostRow {
   
   @IBAction func didTapTripleDots() {
      delegate?.showActionSheet(post: post)
   }
   
   @IBAction func didTapLikeButton() {
      delegate?.likeToPost(post: post)
   }
   
   @IBAction func didTopCommentButton() {
      delegate?.gotoCommentView(postID: post.postID)
      checkIfUserLikedPost()
   }
   
   @IBAction func didTapShareButton() {
      
   }
   
   
   @objc private func didTapUserInfo() {
      if let user = postUser {
         delegate?.gotoProfile(userID: post.userID, postUser: user, displayName: post.username)         
      }
   }
   
}
   

/*
 
width = 300
height = 200
 
 300 / 200 = 1.5
 
 viewheight = 300 / 1.5 = 200
 
 */

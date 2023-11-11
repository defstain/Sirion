//
//  PostImageCell.swift
//  Sirion
//
//  Created by IC Deis on 10/19/23.
//

import UIKit
import Kingfisher

class PostImageCell: UICollectionViewCell {
   
   static let ID = "PostImageCell"
   static func nib() -> UINib { UINib(nibName: "PostImageCell", bundle: nil) }
   
   @IBOutlet var postImage: UIImageView!
   
   
   // MARK: - View Initializations
   override func awakeFromNib() {
      super.awakeFromNib()
   }

}

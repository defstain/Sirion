//
//  UploadPostVC.swift
//  Sirion
//
//  Created by IC Deis on 10/21/23.
//

import UIKit
import Toast

protocol UploadPostDelegate {
   
   func postUploaded()
   
}

class UploadPostVC: UIViewController {

   @IBOutlet var previewImage: UIImageView!
   @IBOutlet var captionField: UITextField!
   @IBOutlet var publishButton: UIButton!
   
   
   // MARK: - Properties
   public var delegate: UploadPostDelegate?
   public var selectedPhoto: UIImage!
   
   private let postManager = PostManager.shared
   private let storageManager = StorageManager.shared
   private var progressView: ProgressView!

   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      dismissKeyboard()
      previewImage.image = selectedPhoto
      isModalInPresentation = true
      
      let progressViewFrame = CGRect(x: view.width / 2 - 50, y: view.height / 2 - 50, width: 100, height: 100)
      progressView = ProgressView(frame: progressViewFrame)
      view.addSubview(progressView)
   }
   
   
   @IBAction func didTapCancel() {
      dismissScreen()
   }
   
   @IBAction func didTapEdit() {
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true)
   }
   
   @IBAction func didTapPublish() {
      publishButton.isEnabled = false
      progressView.startAnimating()
      let caption = captionField.text
      guard let mainUID = UserDefaults.standard.string(forKey: UDKeys.uid) else { return }
      guard let username = UserDefaults.standard.string(forKey: UDKeys.displayName) else { return }
      Task {
         let result = try await storageManager.uploadImage(image: selectedPhoto, filename: UUID().uuidString, bucket: .post)
         try postManager.uploadPost(uid: mainUID, username: username, caption: caption ?? "", imageUrl: result.url)
         progressView.stopAnimating()
         dismissScreen()
         delegate?.postUploaded()
         publishButton.isEnabled = true
      }
   }
   
}


extension UploadPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      guard let image = info[.originalImage] as? UIImage else { return }
      selectedPhoto = image
      previewImage.image = image
   }
   
   private func dismissScreen() {
      dismiss(animated: true)
      previewImage.image = nil
      Toast.text("Your post got published!").show(after: 0.5)
   }
   
}

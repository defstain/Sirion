//
//  ChangeProfilePhotoVC.swift
//  Sirion
//
//  Created by IC Deis on 10/30/23.
//

import UIKit
import Toast

class ChangeProfilePhotoVC: UIViewController {
   
   @IBOutlet var previewImage: UIImageView!
   private var progressView: ProgressView!
   
   
   // MARK: - Properties
   public var profilePhoto: UIImage!
   
   private let userManager = UserManager.shared
   private let storageManager = StorageManager.shared
   private var selectedPhoto: UIImage?
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.isModalInPresentation = true
      setupView()
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      selectedPhoto = nil
   }
   
   
   private func setupView() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
      navigationItem.rightBarButtonItem?.isEnabled = false
      
      previewImage.image = profilePhoto
      
      let progressViewFrame = CGRect(x: view.width / 2 - 50, y: view.height / 2 - 50, width: 100, height: 100)
      progressView = ProgressView(frame: progressViewFrame)
      view.addSubview(progressView)
      
   }
   
   
   @IBAction func editButtonAction() {
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true)
   }
   
   @objc private func saveChanges() {
      guard let selectedPhoto else { return }
      guard let mainUID = mainUserID else { return }
      self.view.isUserInteractionEnabled = false
      progressView.startAnimating()
      
      Task {
         do {
            let result = try await storageManager.uploadImage(image: selectedPhoto, filename: DBUserFields.profilePhoto, bucket: .profile)
            try await userManager.updateProfilePhotoUrl(uid: mainUID, path: result.path, url: result.url)
            
            dismiss(animated: true)
            try await SetMainUserData()
         } catch {
            printConsole(type: .error, error.localizedDescription)
            Toast.text("Error", subtitle: error.localizedDescription).show(haptic: .error, after: 0.5)
         }
         progressView.stopAnimating()
         view.isUserInteractionEnabled = true
      }
   }
   
   @objc private func dismissView() {
      dismiss(animated: true)
   }
}


extension ChangeProfilePhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      guard let image = info[.originalImage] as? UIImage else { return }
      selectedPhoto = image
      previewImage.image = image
      navigationItem.rightBarButtonItem?.isEnabled = true
   }
   
}

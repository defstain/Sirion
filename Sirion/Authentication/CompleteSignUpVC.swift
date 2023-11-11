//
//  CompleteSignUpVC.swift
//  Sirion
//
//  Created by IC Deis on 10/25/23.
//

import UIKit
import FirebaseAuth
import Toast

protocol CompleteSignUpDelegate {
   func signUpCompleted(delegateName: String)
}

class CompleteSignUpVC: UIViewController {

   static let delegateName = "CompleteSignUpDelegate"
   
   @IBOutlet var previewImage: UIImageView!
   @IBOutlet var displayName: UITextField!
   @IBOutlet var username: UITextField!
   @IBOutlet var finishButton: UIButton!
   
   public var userSession: User!
   public var selectedPhoto: UIImage!
   
   var delegate: CompleteSignUpDelegate?
   
   private var userManager = UserManager.shared
   private var storageManager = StorageManager.shared

   override func viewDidLoad() {
      super.viewDidLoad()
      dismissKeyboard()
   }
   
   
   @IBAction func didTapEdit() {
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true)
   }
   
   @IBAction func didTapFinish() {
      makeNewUser()
   }

}


extension CompleteSignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      guard let image = info[.originalImage] as? UIImage else { return }
      selectedPhoto = image
      previewImage.image = image
   }
   
   
   func makeNewUser() {
      guard let user = userSession else { return }
      guard let username = username.text, username.count >= 5, let displayName = displayName.text, displayName.count >= 3 else { return }
      finishButton.isEnabled = false
      Task {
         do {
            let result = try await storageManager.uploadImage(image: selectedPhoto, filename: "profile_photo", bucket: .profile)
            let success = try await userManager.makeNewUser(uid: user.uid, username: username, fullname: displayName,
                                                            email: user.email ?? "no email", provider: "google")
            if success {
               try await SetMainUserData()
               delegate?.signUpCompleted(delegateName: "CompleteSignUpDelegate")
               self.dismiss(animated: true)
            }
            try await userManager.updateProfilePhotoUrl(uid: user.uid, path: result.path, url: result.url)
         } catch {
            printConsole(type: .custom, "Making new user has failed")
            printConsole(type: .error, error.localizedDescription)
            Toast.text(error.localizedDescription).show(haptic: .error, after: 0.5)
         }
         finishButton.isEnabled = true
      }
   }
   
}

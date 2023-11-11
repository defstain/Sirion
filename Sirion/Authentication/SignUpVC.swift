//
//  SignUpVC.swift
//  Sirion
//
//  Created by IC Deis on 10/28/23.
//

import UIKit
import FirebaseAuth
import Toast

protocol SignUpDelegate {
   func signUpCompleted(delegateName: String)
}

class SignUpVC: UIViewController {

   static let segueID = "SignUpSegue"
   static let delegateName = "SignUpDelegate"
   
   @IBOutlet var previewImage: UIImageView!
   @IBOutlet var displayName: UITextField!
   @IBOutlet var username: UITextField!
   @IBOutlet var email: UITextField!
   @IBOutlet var password: UITextField!
   @IBOutlet var signUpButton: UIButton!
   
   var delegate: SignUpDelegate?
   
   private var userManager = UserManager.shared
   private var storageManager = StorageManager.shared
   private var selectedPhoto: UIImage!
   private var userSession: User!

   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   
   @IBAction func didTapEdit() {
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true)
   }
   
   @IBAction func didTapSignUp() {
     signUp()
   }
   
   

}


extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      guard let image = info[.originalImage] as? UIImage else { return }
      selectedPhoto = image
      previewImage.image = image
   }
   
   private func signUp() {
      guard let selectedPhoto else { return }
      guard let email = email.text, email.count > 15, let password = password.text, password.count >= 5 else { return }
      guard let username = username.text, username.count >= 5, let displayName = displayName.text, displayName.count >= 3 else { return }
      signUpButton.isEnabled = false
      Task {
         do {
            let user = try await userManager.signUp(email: email, password: password)
            let image = try await storageManager.uploadImage(image: selectedPhoto, filename: "profile_photo", bucket: .profile)
            let success = try await userManager.makeNewUser(uid: user.uid, username: username, fullname: displayName,
                                                            email: user.email ?? "no email", provider: "google")
            
            if success {
               try await SetMainUserData()
               delegate?.signUpCompleted(delegateName: "SignUpDelegate")
               self.navigationController?.popViewController(animated: true)
            }
            try await userManager.updateProfilePhotoUrl(uid: user.uid, path: image.path, url: image.url)
         } catch {
            printConsole(type: .error, "Making new user has failed!")
            printConsole(type: .error, "Sign Up " + error.localizedDescription)
            Toast.text(error.localizedDescription).show(haptic: .error, after: 0.5)
         }
         signUpButton.isEnabled = true
         Toast.text("Success!").show(after: 0.5)
      }
   }
   
}

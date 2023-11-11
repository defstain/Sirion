//
//  SignInVC.swift
//  Sirion
//
//  Created by IC Deis on 10/28/23.
//

import UIKit
import FirebaseAuth
import Toast

protocol SignInDelegate {
   func signInCompleted()
}

class SignInVC: UIViewController {

   static let segueID = "SignInSegue"
   
   @IBOutlet var email: UITextField!
   @IBOutlet var password: UITextField!
   @IBOutlet var signInButton: UIButton!
   
   var delegate: SignInDelegate?
   private let userManager = UserManager.shared
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   
   @IBAction func didTapSignIn() {
      guard let email = email.text, email.count > 15, let password = password.text, password.count >= 5 else { return }
      signInButton.isEnabled = false
      Task {
         do {
            let _ = try await userManager.signIn(email: email, password: password)
            try await SetMainUserData()
            delegate?.signInCompleted()
            navigationController?.popViewController(animated: true)
         } catch {
            printConsole(type: .custom, "User not found")
            printConsole(type: .error, error.localizedDescription)
            Toast.text("Email or password is incorrect!").show(haptic: .error, after: 0.5)
         }
         signInButton.isEnabled = true
      }
   }
   

}

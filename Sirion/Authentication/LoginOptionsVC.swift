//
//  LoginOptionsVC.swift
//  Sirion
//
//  Created by IC Deis on 10/24/23.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

protocol LoginOptionsDelegate {

   func loginCompleted()
   
}

class LoginOptionsVC: UIViewController {
   
   var delegate: LoginOptionsDelegate?
   private var userManager = UserManager.shared
   private var storageManager = StorageManager.shared
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
   }

   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == SignInVC.segueID {
         let vc = segue.destination as! SignInVC
         vc.delegate = self
      }
      if segue.identifier == SignUpVC.segueID {
         let vc = segue.destination as! SignUpVC
         vc.delegate = self
      }
   }
   
   
   @IBAction func didTapAppleSignIn() { }
   
   @IBAction func didTapGoogleSignIn() {
      Task {
         try await signInWithGoogle()
      }
   }
   
   @IBAction func didTapAsGuest() {
      dismiss(animated: true)
   }
   
   
   
}


extension LoginOptionsVC: CompleteSignUpDelegate, SignUpDelegate, SignInDelegate {
   
   private func signInWithGoogle() async throws {
      guard let clientID = FirebaseApp.app()?.options.clientID else { return }
      
      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance.configuration = config
      do {
         let authResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
         guard let idToken = authResult.user.idToken?.tokenString else { throw URLError(.userCancelledAuthentication) }
         let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authResult.user.accessToken.tokenString)
         let user = try await userManager.signInUser(credential: credential)
         
         do {
            try await SetMainUserData()
            delegate?.loginCompleted()
            dismiss(animated: true)
         } catch {
            let vc = CompleteSignUpVC.instantiate("Authorization")
            vc.delegate = self
            vc.userSession = user
            vc.isModalInPresentation = true
            self.present(vc, animated: true)
         }
         
      } catch {
         printConsole(type: .error, error.localizedDescription)
      }
   }
   
   
   func signUpCompleted(delegateName: String) {
      if delegateName == CompleteSignUpVC.delegateName {
         delegate?.loginCompleted()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
         }
      } else if delegateName == SignUpVC.delegateName {
         delegate?.loginCompleted()
         dismiss(animated: true)
      }
   }
   
   func signInCompleted() {
      delegate?.loginCompleted()
      dismiss(animated: true)
   }
   
   
}

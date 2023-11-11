//
//  ProfileNavigation.swift
//  Sirion
//
//  Created by IC Deis on 10/24/23.
//

import UIKit
import Toast

class ProfileNavigation: UINavigationController {

   private let authVM = AuthenticationVM()
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
     checkAuthorization()
   }
   
   
   private func checkAuthorization() {
      let isAuth = UserDefaults.standard.string(forKey: UDKeys.uid)
      if isAuth == nil {
         let onboardingVC = OnboardingVC.instantiate("Authorization")
         onboardingVC.delegate = self
         setViewControllers([onboardingVC], animated: true)
      } else {
         let profileVC = ProfileVC.instantiate()
         profileVC.modalTransitionStyle = .flipHorizontal
         profileVC.delegate = self
         setViewControllers([profileVC], animated: true)
      }
   }
   
   

}


extension ProfileNavigation: OnboradingDelegate, ProfileDelegate {
   
   func userLoggedIn() {
      checkAuthorization()
   }
   
   func userSignedOut() {
      checkAuthorization()
   }
   
}

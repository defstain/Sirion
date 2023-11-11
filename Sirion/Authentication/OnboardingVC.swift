//
//  OnboardingVC.swift
//  Sirion
//
//  Created by IC Deis on 10/24/23.
//

import UIKit

protocol OnboradingDelegate {
   
   func userLoggedIn()

}

class OnboardingVC: UIViewController {
   
   var delegate: OnboradingDelegate?
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      tabbarColor(tint: .white, barTint: .white)
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      tabbarColor(tint: .label, barTint: .systemBackground)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "LoginOptionsSegue" {
         let nc = segue.destination as! UINavigationController
         let vc = nc.topViewController as! LoginOptionsVC
         vc.delegate = self
      }
   }
   
}


extension OnboardingVC: LoginOptionsDelegate {
   
   func loginCompleted() {
      delegate?.userLoggedIn()
   }
   
}

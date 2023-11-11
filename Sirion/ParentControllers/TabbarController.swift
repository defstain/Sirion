//
//  TabbarController.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit

class TabbarController: UITabBarController {

   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      let profile = ProfileNavigation.instantiate()
      addChild(profile)
      setMainUserPhoto()
   }


   private func setMainUserPhoto() {
      guard let mainUID = mainUserID else { return }
      StorageManager.shared.getProfilePhoto(withUid: mainUID) { image in
         saveImageToUserDefaults(image: image, key: UDKeys.photo)
      }
   }

}


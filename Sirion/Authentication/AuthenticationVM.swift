//
//  AuthenticationVM.swift
//  Sirion
//
//  Created by IC Deis on 10/25/23.
//

import UIKit
import FirebaseAuth

class AuthenticationVM: ObservableObject {
   @Published var userSession: User?
   @Published var dbuser: DBUser?
   @Published var isSignedUp: Bool = false
   
   @Published var displayName: String = ""
   @Published var username: String = ""
   @Published var selectedPhoto: UIImage?
   
   private var userManager = UserManager.shared
   private var storageManager = StorageManager.shared
   
   
   
   init() {
      getUserCurrent()
   }

   
   func getUserCurrent() {
      guard let user = Auth.auth().currentUser else { return }
      Task {
         let dbuser = try await userManager.getUser(withUId: user.uid)
         self.dbuser = dbuser
         UserDefaults.standard.set(dbuser.uid, forKey: UDKeys.uid)
         UserDefaults.standard.set(dbuser.displayName, forKey: UDKeys.displayName)
         
         saveToUserDefaults(data: dbuser, key: UDKeys.dbuser)
      }
   }
   
   
   func signOut() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
         do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: UDKeys.uid)
            UserDefaults.standard.removeObject(forKey: UDKeys.username)
            UserDefaults.standard.removeObject(forKey: UDKeys.displayName)
            UserDefaults.standard.removeObject(forKey: UDKeys.bio)
            UserDefaults.standard.removeObject(forKey: UDKeys.photo)
            UserDefaults.standard.removeObject(forKey: UDKeys.dbuser)
            self.userSession = nil
         } catch  {
            printConsole(type: .error, error.localizedDescription)
         }
      }
   }
   
}

// MARK: -- Make New User
extension AuthenticationVM {
   func makeNewUser() {
      guard let user = userSession else { return }
      guard let selectedPhoto else { return }
      guard username.count >= 5, displayName.count >= 5 else { return }
      
      Task {
         do {
            let result = try await storageManager.uploadImage(image: selectedPhoto, filename: "profile_photo", bucket: .profile)
            let success = try await userManager.makeNewUser(uid: user.uid, username: username, fullname: displayName,
                                                            email: user.email ?? "no email", provider: "google")
            if success {
               getUserCurrent()
               isSignedUp = true
            }
            try await userManager.updateProfilePhotoUrl(uid: user.uid, path: result.path, url: result.url)
         } catch {
            printConsole(type: .error, error.localizedDescription)
         }
      }
   }
}

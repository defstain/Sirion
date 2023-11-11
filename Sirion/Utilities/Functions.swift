//
//  Functions.swift
//  InstaDC
//
//  Created by IC Deis on 6/24/23.
//

import SwiftUI
import Combine
import FirebaseAuth

/// Clears all saved values from UserDefaults
func clearUserDefualts() {
   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      UserDefaults.standard.dictionaryRepresentation().forEach { key, _ in
         UserDefaults.standard.removeObject(forKey: key)
      }
   }
}


/// Generic function to save data to UserDefaults
func saveToUserDefaults<T: Codable>(data: T, key: String) {
   let encoder = JSONEncoder()
   if let data = try? encoder.encode(data) {
      UserDefaults.standard.set(data, forKey: "dbuser")
   }
}

/// Genereic function to get data from UserDefaults
func getFromUserDefaults<T: Codable>(as type: T.Type, key: String) -> T? {
   guard let udData = UserDefaults.standard.data(forKey: key) else { return nil }
   guard let decoded = try? JSONDecoder().decode(T.self, from: udData) else { return nil }
   return decoded
}

/// Saves the image to UserDefaults
func saveImageToUserDefaults(image: UIImage, key: String) {
   guard let data = image.jpegData(compressionQuality: 0.5) else { return }
   let encoded = try! PropertyListEncoder().encode(data)
   UserDefaults.standard.set(encoded, forKey: key)
}

/// Gets the image from UserDefaults
func getImageFromUserDefaults(key: String) -> UIImage? {
   guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
   let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
   return UIImage(data: decoded)
   
}

/// Validation
func userValidate(Input:String) -> Bool {
   return Input.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
}
//('/^[A-Za-z0-9_]+$/', $username)


func checkCompletion(completion: Subscribers.Completion<Error>) {
   switch completion {
   case .finished:
      print("Downloading completion finished!")
   case .failure(let error):
      print("Downloading completion failed. \(error.localizedDescription)")
   }
}

var mainUserID: String? {
   return UserDefaults.standard.string(forKey: UDKeys.uid)
}

/// Fetches current user data and sets them to UserDefaults
func SetMainUserData() async throws {
   guard let user = Auth.auth().currentUser else { return }
   let mainUser = try await UserManager.shared.getUser(withUId: user.uid)
   
   UserDefaults.standard.set(mainUser.uid, forKey: UDKeys.uid)
   UserDefaults.standard.set(mainUser.displayName, forKey: UDKeys.displayName)
   saveToUserDefaults(data: mainUser, key: UDKeys.dbuser)
   if let imageUrl = user.photoURL {
      UserDefaults.standard.setValue(imageUrl, forKey: UDKeys.photoUrl)
   }
}

func printConsole(type: ConsoleType, _ text: String) {
   switch type {
   case .sucess:
      print("DEF: SUCCESS - \(text)")
   case .error:
      print("DEF: ERROR - \(text)")
   case .funcCalled:
      print("DEF: \(text) function")
   case .custom:
      print("DEF: \(text)")
   }
}

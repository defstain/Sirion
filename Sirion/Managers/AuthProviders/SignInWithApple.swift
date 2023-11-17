//
//  SignInWithApple.swift
//  Sirion
//
//  Created by IC Deis on 6/21/23.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

/// Apple sign in method
class SignInWithApple: NSObject, ASAuthorizationControllerDelegate {
   
   static let shared = SignInWithApple()
   
   // Unhashed nonce.
   fileprivate var currentNonce: String?
   
   func startSignInWithAppleFlow() {
      
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      //     authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
   }
   
   private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
         String(format: "%02x", $0)
      }.joined()
      
      return hashString
   }
   
   private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
         fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
         )
      }
      
      let charset: [Character] =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      
      let nonce = randomBytes.map { byte in
         // Pick a random character from the set, wrapping around if needed.
         charset[Int(byte) % charset.count]
      }
      
      return String(nonce)
   }
   
   
}


extension SignInWithApple {
   
   func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
         guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
         }
         guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
         }
         guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
         }
         
//         let email = appleIDCredential.email ?? ""
//         var name: String = "no name"
//         if let fullname = appleIDCredential.fullName {
//            let formatter = PersonNameComponentsFormatter()
//            name = formatter.string(from: fullname)
//         }
         
         
         // Initialize a Firebase credential, including the user's full name.
         let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
         // Sign in with Firebase.
         
         print("DEBUG: AppleID Credential - \(credential)")
      }
   }
   
   func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
   }
   
}

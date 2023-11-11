//
//  SignInWithGoogle.swift
//  InstaDC
//
//  Created by IC Deis on 6/22/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
//import GoogleSignInSwift

/// Google sign in method
@MainActor
final class GoogleSignInHelper {
   
   static let shared = GoogleSignInHelper()
   
   func signIn() async throws -> AuthCredential {
      
      configGIDSignIn()
      guard let rootViewController = getRootViewController() else { throw URLError(.badServerResponse) }
      
      do {
         let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
         let user = userAuth.user
         let credential = try getCredential(user: user)
         
         return credential
      } catch {
         print("DEBUG: Error getting user idToken. \(error.localizedDescription)")         
         throw URLError(.badServerResponse)
      }
   }
   
   private func configGIDSignIn() {
      guard let clientID = FirebaseApp.app()?.options.clientID else { fatalError("DEBUG: No client found in Firebase configuration.") }
      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance.configuration = config
   }
   
   private func getCredential(user: GIDGoogleUser) throws -> AuthCredential {
      guard let idToken = user.idToken else { throw URLError(.badServerResponse) }
      let accessToken = user.accessToken
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
      return credential
   }
   
}

//
//  ChangeProfileInfoVC.swift
//  Sirion
//
//  Created by IC Deis on 10/30/23.
//

import UIKit
import Toast

class ChangeProfileInfoVC: UIViewController {

   @IBOutlet var textInput: UITextField!
   private var progressView: ProgressView!
   
   
   // MARK: - Properties
   public var infoText: String = ""
   public var option: ChangingsOptions?
   
   private let userMananger = UserManager.shared
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      navigationController?.isModalInPresentation = true
      setupView()
   }
   
   
   private func setupView() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
      navigationItem.rightBarButtonItem?.isEnabled = false
      
      textInput.text = infoText
      textInput.addTarget(self, action: #selector(inputChanges), for: .editingChanged)
      
      let progressViewFrame = CGRect(x: view.width / 2 - 50, y: view.height / 2 - 50, width: 100, height: 100)
      progressView = ProgressView(frame: progressViewFrame)
      view.addSubview(progressView)
   }
   
   @objc private func saveChanges() {
      guard let newText = textInput.text?.trimmingCharacters(in: .whitespaces) else { return }
      guard let option else { return }
      guard let mainUID = mainUserID else { return }
      self.view.isUserInteractionEnabled = false
      progressView.startAnimating()
      Task {
         do {
            switch option {
            case .displayName:
               guard newText.count >= 3 else { return }
               try await userMananger.updateDisplayName(uid: mainUID, displayName: newText)
            case .username:
               guard newText.count >= 5 else { return }
               try await userMananger.updateUsername(uid: mainUID, username: newText)
            case .bio:
               try await userMananger.updateUserBio(uid: mainUID, bio: textInput.text ?? "")
            case .city:
               try await userMananger.updateUserCity(uid: mainUID, city: newText)
            }
            dismiss(animated: true)
            try await SetMainUserData()
         } catch {
            printConsole(type: .error, error.localizedDescription)
            Toast.text("Error", subtitle: error.localizedDescription).show(haptic: .error, after: 0.5)
         }
         progressView.stopAnimating()
         view.isUserInteractionEnabled = true
      }
   }
   
   @objc private func dismissView() {
      dismiss(animated: true)
   }
   
   @objc private func inputChanges() {
      if textInput.text != infoText {
         navigationItem.rightBarButtonItem?.isEnabled = true
      }
   }

}


extension ChangeProfileInfoVC {
   
   enum ChangingsOptions {
      case displayName
      case username
      case bio
      case city
   }
   
}

//
//  UploadVC.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit
import Toast

class UploadVC: UIViewController {

   private var selectedPhoto: UIImage?
   
   
   // MARK: - View Lifecycles
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
   
   
   @IBAction func didTapUpload() {
      let picker = UIImagePickerController()
      picker.delegate = self

      let controller = UIAlertController(title: "Upload", message: nil, preferredStyle: .actionSheet)
      let fromCameraAC = UIAlertAction(title: "from Camera", style: .default) { [weak self] _ in
         picker.sourceType = .camera
         self?.present(picker, animated: true)
      }
      let fromLibraryAC = UIAlertAction(title: "from Library", style: .default) { [weak self] _ in
         picker.sourceType = .photoLibrary
         self?.present(picker, animated: true)
      }
      let cancelAC = UIAlertAction(title: "Cancel", style: .cancel)
      
      controller.addAction(fromCameraAC)
      controller.addAction(fromLibraryAC)
      controller.addAction(cancelAC)
      
      present(controller, animated: true)
   }


}


extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)
      guard let image = info[.originalImage] as? UIImage else { return }
      selectedPhoto = image
      
      let vc = UploadPostVC.instantiate() as UploadPostVC
      vc.selectedPhoto = image
      present(vc, animated: true)
   }
   

}

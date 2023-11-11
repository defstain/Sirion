//
//  SettingsVC.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit
import Kingfisher

// MARK: - Delegate
protocol SettingsDelegate {
   func signOut()
}

class SettingsVC: UIViewController {

   @IBOutlet var tableView: UITableView!
   
   
   // MARK: - Properties
   public var delegate: SettingsDelegate?
   public var profilePhoto: UIImage?
   
   private var sectionsArray = [SettingSectionModel]()
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationController?.navigationBar.prefersLargeTitles = true
      self.navigationItem.largeTitleDisplayMode = .always
      
      setSubviews()
      getSettingsOptions()
   }
   
   
   @IBAction func xmarkAction() {
      dismiss(animated: true)
   }
   
   
   private func setSubviews() {
      tableView.register(SettingRow.self, forCellReuseIdentifier: SettingRow.ID)
      tableView.register(SettingsAboutApp.nib(), forCellReuseIdentifier: SettingsAboutApp.ID)
      let header = HeaderForSettings(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
      tableView.tableHeaderView = header
   }
   
   private func getSettingsOptions() {
      let sections = DeveloperService.shared.getSettingOptions()
      sectionsArray = sections
      tableView.reloadData()
   }
   
}


extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return sectionsArray.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
         return sectionsArray[0].rows.count
      } else if section == 1 {
         return sectionsArray[1].rows.count
      } else {
         return sectionsArray[2].rows.count
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.section == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: SettingRow.ID, for: indexPath) as! SettingRow
         let model = sectionsArray[0].rows[indexPath.row]
         cell.configureUI(model: model)
         return cell
      } else if indexPath.section == 1 {
         let cell = tableView.dequeueReusableCell(withIdentifier: SettingRow.ID, for: indexPath) as! SettingRow
         let model = sectionsArray[1].rows[indexPath.row]
         cell.configureUI(model: model)
         return cell
      } else {
         let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAboutApp.ID, for: indexPath) as! SettingsAboutApp
         return cell
      }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      if indexPath.section == 0 {
         guard let mainUser = getFromUserDefaults(as: DBUser.self, key: UDKeys.dbuser) else { return }
         switch indexPath.row {
         case 0:
            let vc = ChangeProfilePhotoVC.instantiate()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            if let profilePhoto {
               vc.profilePhoto = profilePhoto
            } else {
               vc.previewImage.kf.setImage(with: UDKeys.photoUrl.asURL)
            }
            present(nc, animated: true)
            
         case 1:
            let vc = ChangeProfileInfoVC.instantiate()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            vc.infoText = mainUser.displayName
            vc.option = .displayName
            present(nc, animated: true)
            
         case 2:
            let vc = ChangeProfileInfoVC.instantiate()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            vc.infoText = mainUser.username
            vc.option = .username
            present(nc, animated: true)
            
         case 3:
            let vc = ChangeProfileInfoVC.instantiate()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            vc.infoText = mainUser.bio ?? ""
            vc.option = .bio
            present(nc, animated: true)
            
         case 4:
            let vc = ChangeProfileInfoVC.instantiate()
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            vc.infoText = mainUser.city ?? ""
            vc.option = .city
            present(nc, animated: true)
            
         case 5:
            break
         case 6:
            showSignOutAction()
         default:
            break
         }
      }
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 2 {
         return 130
      } else {
         return 55
      }
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      if section == 0 {
         return 30
      } else { 
         return 0
      }
   }
   
   func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      if section == 2 {
         return 30
      } else {
         return 0
      }
   }
   
}


extension SettingsVC {
   
   private func showSignOutAction() {
      let ac = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
      let signout = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
         try? UserManager.shared.signOut()
         self?.delegate?.signOut()
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self?.dismiss(animated: true)
         }
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel)
      ac.addAction(signout)
      ac.addAction(cancel)
      present(ac, animated: true)
   }
   
}

//
//  SearchResultVC.swift
//  Sirion
//
//  Created by IC Deis on 10/23/23.
//

import UIKit

class SearchResultVC: UIViewController {

   let tableView: UITableView = {
      let tableView = UITableView()
      tableView.register(UserRow.nib(), forCellReuseIdentifier: UserRow.ID)
      return tableView
   }()
   
   var usersArray: [DBUser] = [] {
      didSet {
         tableView.reloadData()
      }
   }
   
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      
      view.addSubview(tableView)
      tableView.separatorStyle = .none
      tableView.delegate = self
      tableView.dataSource = self
   }

   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      tableView.frame = view.bounds
   }
   
}


extension SearchResultVC: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return usersArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: UserRow.ID, for: indexPath) as! UserRow
      let user = usersArray[indexPath.row]
      cell.configureUI(user: user)
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      let profile = UserProfileVC.instantiate()
      let user = usersArray[indexPath.row]
      profile.userID = user.uid
      navigationController?.show(profile, sender: self)
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 50
   }
   
}

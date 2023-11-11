////
////  SearchBarView.swift
////  Sirion
////
////  Created by IC Deis on 10/23/23.
////
//
//import UIKit
//
//class SearchBarView: UICollectionReusableView {
//   
//   static let ID = "SearchBarView"
//   
//   private let searchBar: UISearchBar = {
//      let searchBar = UISearchBar()
//      searchBar.placeholder = "Search"
//      return searchBar
//   }()
//   
//
//   // MARK: - View Lifecycles
//   override init(frame: CGRect) {
//      super.init(frame: frame)
//      
//      setSubview()
//      applyConstraints()
//   }
//   
//   required init?(coder: NSCoder) {
//      super.init(coder: coder)
//      setSubview()
//   }
//   
//   
//   private func setSubview() {
//      addSubview(searchBar)
//   }
//   
//   private func applyConstraints() {
//      let constraints = [
//         searchBar.topAnchor.constraint(equalTo: topAnchor),
//         searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//         searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//         searchBar.heightAnchor.constraint(equalToConstant: 40)
//      ]
//      
//      NSLayoutConstraint.activate(constraints)
//   }
//   
//   
//   
//}

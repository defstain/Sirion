//
//  ExploreVC.swift
//  Sirion
//
//  Created by IC Deis on 10/16/23.
//

import UIKit
import Combine

class ExploreVC: UIViewController {


   @IBOutlet var collectionView: UICollectionView!
   private var searchBarController = UISearchController(searchResultsController: SearchResultVC())
   private var searchResult: SearchResultVC?
   private let refreshControl = UIRefreshControl()
   
   // MARK: - Properties
   private let vm = ExploreVM()
   private let userManager = UserManager.shared
   private var cancellables = Set<AnyCancellable>()
   private var postsArray = [Post]()
   private var usersArray = [DBUser]()
   
   // MARK: - View Lifecycles
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupSearchBar()
      setupCollectionView()
      getPosts()
      addSubscribers()
   }

   
   private func setupSearchBar() {
      navigationItem.searchController = searchBarController
      searchBarController.searchBar.delegate = self
      searchBarController.searchResultsUpdater = self
      searchBarController.obscuresBackgroundDuringPresentation = true
      searchResult = searchBarController.searchResultsController as? SearchResultVC
   }
   
   private func setupCollectionView() {
      collectionView.register(PostImageCell.nib(), forCellWithReuseIdentifier: PostImageCell.ID)
      collectionView.collectionViewLayout = compositeLayout()
      collectionView.refreshControl = refreshControl
      refreshControl.addTarget(self, action: #selector(didPullDown), for: .valueChanged)
   }
   
   private func getPosts() {
      Task {
         postsArray = try await PostManager.shared.getAllPosts()
         collectionView.reloadData()
      }
   }
   
   private func addSubscribers() {
      vm.$searchBarText
         .debounce(for: 0.5, scheduler: DispatchQueue.main)
         .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
               printConsole(type: .sucess, "Searching users was finished!")
            case .failure(let error):
               printConsole(type: .error, error.localizedDescription)
            }
         }, receiveValue: { [weak self] query in
            guard query.count >= 2 else { return }
            Task {
               if let users = try await self?.userManager.getUsers(username: query.lowercased()) {
                  self?.usersArray = users
                  printConsole(type: .custom, "Users Count" + "\(users.count)")
                  self?.searchResult?.usersArray = users
               }
            }
         })
         .store(in: &cancellables)
   }
   
   @objc private func didPullDown() {
      getPosts()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
         self.refreshControl.endRefreshing()
      }
   }

}

extension ExploreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating {
   
   func updateSearchResults(for searchController: UISearchController) {
      if let query = searchController.searchBar.text {
         vm.searchBarText = query
         if query.isEmpty, query.count < 2 {
            searchResult?.usersArray = []
         }
      }
   }
   
   
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return postsArray.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostImageCell.ID, for: indexPath) as! PostImageCell
      let post = postsArray[indexPath.row]
      cell.postImage.kf.setImage(with: post.imageURL.asURL)
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let size = (view.width / 3) - 2
      return CGSize(width: size, height: size)
   }
   
   func compositeLayout() -> UICollectionViewCompositionalLayout {
      let insets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
      
      let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1))
      let itemLayoutSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
      let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
      let item2 = NSCollectionLayoutItem(layoutSize: itemLayoutSize2)
      item.contentInsets = insets
      item2.contentInsets = insets
      
      let verticalGroupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
      let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupLayoutSize, subitem: item2, count: 2)
      
      let groupLayoutSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
      let groupLayoutSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
      let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize1, subitems: [item, verticalGroup])
      let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize1, subitems: [verticalGroup, item])
      
      let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [group1, group2])
      
      let section = NSCollectionLayoutSection(group: group)
      
      return UICollectionViewCompositionalLayout(section: section)
   }

   
}

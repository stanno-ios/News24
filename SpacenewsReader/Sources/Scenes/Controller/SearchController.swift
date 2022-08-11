//
//  SearchController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit

class SearchController: UIViewController {
    
    let manager = NetworkManager()
    var articles: [Article] = []
    
    private var searchView: SearchView? {
        guard isViewLoaded else { return nil }
        return view as? SearchView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = SearchView()
        searchView?.collectionView.delegate = self
        searchView?.collectionView.dataSource = self
        manager.searchDelegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        cell.configure(with: articles[indexPath.item])
        cell.makeMenu(for: articles[indexPath.row], viewController: self)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchBarReusableHeaderView.identifier, for: indexPath) as! SearchBarReusableHeaderView
            view.searchBar.delegate = self
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        manager.searchByKeywords(keywords: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        articles = []
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.searchView?.collectionView.reloadData()
    }
}

// MARK: - SearchDelegate

extension SearchController: SearchDelegate {
    func updateSearchResults(with data: [Article]) {
        DispatchQueue.main.async {
            self.articles = data
            self.searchView?.collectionView.reloadData()
        }
    }
}

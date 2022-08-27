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
        searchView?.searchBar.placeholder = Strings.placeholder
        searchView?.searchBar.delegate = self
        navigationItem.titleView = searchView?.searchBar
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
        let article = DisplayableArticle(title: articles[indexPath.item].title, author: articles[indexPath.item].author, category: articles[indexPath.item].category[0], url: articles[indexPath.item].url, description: articles[indexPath.item].description, imagePath: articles[indexPath.item].image)
        cell.configure(with: article)
        MenuHandler.makeMenu(for: cell, with: article, viewController: self, indexPath: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell else { return }
        let readerController = ReaderController()
        readerController.article = articles[indexPath.row]
        readerController.image = cell.getImage()
        navigationController?.pushViewController(readerController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        manager.searchByKeywords(keywords: text)
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

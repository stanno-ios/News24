//
//  ViewController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/9/22.
//

import UIKit

class NewsController: UIViewController {
    
    // MARK: - Properties
    
    let manager = NetworkManager()
    var articles: [Article] = []
    var tempArticles: [Article] = []
    var cellStatus: NSMutableDictionary = NSMutableDictionary()
    
    private var newsView: NewsView? {
        guard isViewLoaded else { return nil }
        return view as? NewsView
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = NewsView()
        navigationItem.title = Strings.title
        
        newsView?.collectionView.delegate = self
        newsView?.collectionView.dataSource = self
        manager.delegate = self
        manager.fetchArticles()
        newsView?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }
}

// MARK: - UICollectionViewDataSource

extension NewsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Strings.categories.count
        case 1:
            return articles.count
        default: return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.isSelected = (cellStatus[indexPath.row] as? Bool) ?? false
            cell.configure(with: Strings.categories[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            
            let article = DisplayableArticle(title: articles[indexPath.item].title, author: articles[indexPath.item].author, category: articles[indexPath.item].category[0], url: articles[indexPath.item].url, description: articles[indexPath.item].description, imagePath: articles[indexPath.item].image)
            cell.configure(with: article)
            cell.makeMenu(for: article, viewController: self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension NewsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            cell.isSelected = true
            self.cellStatus[indexPath.row] = true
            
            if let category = cell.label.text, category != "Latest" {
                manager.applyFilter(category: cell.label.text!.lowercased())
            } else {
                self.articles = tempArticles
                self.newsView?.collectionView.reloadSections(IndexSet(integer: 1))
            }
        } else {
            let readerController = ReaderController()
            readerController.article = articles[indexPath.row]
            navigationController?.pushViewController(readerController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        cell.isSelected = false
        self.cellStatus[indexPath.row] = false
        }
    }
}

// MARK: - CategoriesDelegate

extension NewsController: CategoriesDelegate {
    func updateCells(with model: [Article]) {
        DispatchQueue.main.async {
            self.articles = model
            self.tempArticles = model
            self.newsView?.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    
    func reloadFiltered(with model: [Article]) {
        DispatchQueue.main.async {
            self.articles = model
            self.newsView?.collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
}

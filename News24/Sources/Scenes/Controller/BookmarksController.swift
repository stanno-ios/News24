//
//  BookmarksController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit
import CoreData

class BookmarksController: UIViewController {
    
    var databaseManager: DatabaseManager?
    var fileManager: LocalStorageManager?
    private var savedArticles: [SavedArticle]?
    
    private var bookmarksView: BookmarksView? {
        guard isViewLoaded else { return nil }
        return view as? BookmarksView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = BookmarksView()
        navigationItem.title = Strings.title
        bookmarksView?.collectionView.delegate = self
        bookmarksView?.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseManager = DatabaseManager()
        fileManager = LocalStorageManager()
        savedArticles = databaseManager?.fetchData()
        bookmarksView?.collectionView.reloadData()
        
        if bookmarksView?.collectionView.numberOfItems(inSection: 0) != 0 {
            self.bookmarksView?.emptyLabel.isHidden = true
        }
    }
}

extension BookmarksController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let articles = savedArticles else { return 0 }
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        guard let articles = savedArticles else { return UICollectionViewCell() }
        let article = DisplayableArticle(title: articles[indexPath.item].title!, author: articles[indexPath.item].author!, category: articles[indexPath.item].category!, url: articles[indexPath.item].url!, description: articles[indexPath.item].description, imagePath: articles[indexPath.item].imagePath!.path)
        cell.configureFromDB(with: article)
        MenuHandler.makeMenu(for: cell, with: article, viewController: self, indexPath: indexPath)
        return cell
    }
}

extension BookmarksController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let readerController = ReaderController()
        let cell = collectionView.cellForItem(at: indexPath) as! NewsCollectionViewCell
        readerController.savedArticle = savedArticles![indexPath.item]
        readerController.image = cell.getImage()
        navigationController?.pushViewController(readerController, animated: true)
    }
}

extension BookmarksController: DeletionDelegate {
    func deleteArticle(indexPath: IndexPath) {
        guard let articles = savedArticles else { return }
        fileManager?.delete(file: articles[indexPath.item].imagePath!.path)
        databaseManager?.delete(item: articles[indexPath.item])
        bookmarksView?.collectionView.deleteItems(at: [indexPath])
        savedArticles?.remove(at: indexPath.item)
        
        self.bookmarksView?.collectionView.reloadData()
        
        if bookmarksView?.collectionView.numberOfItems(inSection: 0) == 0 {
            bookmarksView?.emptyLabel.isHidden = false
        }
    }
}

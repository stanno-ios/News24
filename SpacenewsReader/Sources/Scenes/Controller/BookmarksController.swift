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
    private var savedCategories: [SavedCategory]?
    private var savedArticles: [SavedArticle]?
    private var tempArticles: [SavedArticle]?
    var cellStatus: NSMutableDictionary = NSMutableDictionary()
    
    private var bookmarksView: BookmarksView? {
        guard isViewLoaded else { return nil }
        return view as? BookmarksView
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = BookmarksView()
        navigationItem.title = "Bookmarked"
        bookmarksView?.collectionView.delegate = self
        bookmarksView?.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseManager = DatabaseManager()
        fileManager = LocalStorageManager()
        savedArticles = databaseManager?.fetchData()
        savedCategories = databaseManager?.fetchCategories()
        tempArticles = databaseManager?.fetchData()
        bookmarksView?.collectionView.reloadData()
    }
}

extension BookmarksController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let categories = savedCategories else { return 0 }
            return categories.count
        case 1:
            guard let articles = savedArticles else { return 0 }
            return articles.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            guard let categories = savedCategories, let category = categories[indexPath.item].category else { return UICollectionViewCell() }
            cell.configure(with: category)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            guard let articles = savedArticles else { return UICollectionViewCell() }
            let article = DisplayableArticle(title: articles[indexPath.item].title!, author: articles[indexPath.item].author!, category: articles[indexPath.item].category!, url: articles[indexPath.item].url!, description: articles[indexPath.item].description, imagePath: articles[indexPath.item].imagePath!.path)
            cell.configureFromDB(with: article)
            cell.makeMenu(for: article, viewController: self, indexPath: indexPath)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension BookmarksController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            cell.isSelected = true
            self.cellStatus[indexPath.row] = true
            
//            if let category = cell.label.text, category != "Latest" {
//                savedArticles = savedArticles?.filter({ article in
//                    article.category == category
//                })
//                collectionView.reloadSections(IndexSet(integer: 1))
            } else {
//                self.articles = tempArticles
//                self.newsView?.collectionView.reloadSections(IndexSet(integer: 1))
            }
//        } else {
//            let readerController = ReaderController()
//            readerController.article = DisplayableArticle(title: <#T##String#>, author: <#T##String#>, category: <#T##String#>, url: <#T##String#>, description: <#T##String#>, imagePath: <#T##String#>)
//            navigationController?.pushViewController(readerController, animated: true)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            cell.isSelected = false
            self.cellStatus[indexPath.row] = false
//            savedArticles = databaseManager?.fetchData()
        }
    }
}

extension BookmarksController: DeletionDelegate {
    func deleteArticle(indexPath: IndexPath) {
        guard let articles = savedArticles else { return }
        guard let categories = savedCategories else { return }
        fileManager?.delete(file: articles[indexPath.item].imagePath!.path)
        databaseManager?.delete(item: articles[indexPath.item])
       
        for category in categories {
            if !articles.contains(where: { article in
                return article.category == category.category
            }) {
                databaseManager?.deleteCategory(item: category)
                bookmarksView?.collectionView.deleteItems(at: [indexPath])
                savedCategories?.remove(at: indexPath.item)
                self.bookmarksView?.collectionView.reloadData()
            }
        }
        
        bookmarksView?.collectionView.deleteItems(at: [indexPath])
        savedArticles?.remove(at: indexPath.item)
        self.bookmarksView?.collectionView.reloadData()
    }
}

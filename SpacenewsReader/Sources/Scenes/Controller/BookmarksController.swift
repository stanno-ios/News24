//
//  BookmarksController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit
import CoreData

class BookmarksController: UIViewController {
    
    let databaseManager = DatabaseManager()
    let fileManager = LocalStorageManager()
    private var savedCategories: [SavedCategory] = []
    private var savedArticles: [SavedArticle] = []
    
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
        savedArticles = databaseManager.fetchData()!
        savedCategories = databaseManager.fetchCategories()!
//        databaseManager.deleteAllData(entity: "SavedCategory")
//        databaseManager.deleteAllData(entity: "SavedArticle")
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
            return savedCategories.count
        case 1:
            return savedArticles.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(with: savedCategories[indexPath.item].category!)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            cell.configureFromDB(with: savedArticles[indexPath.item])
            let article = DisplayableArticle(title: savedArticles[indexPath.item].title!, author: savedArticles[indexPath.item].author!, category: savedArticles[indexPath.item].category!, url: savedArticles[indexPath.item].url!, description: savedArticles[indexPath.item].description, imagePath: savedArticles[indexPath.item].imagePath!.path)
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
        if indexPath.section == 1 {
//            guard let article = savedArticles[indexPath.item] as? SavedArticle else { return }
//            fileManager.delete(file: savedArticles[indexPath.item].imagePath!.path)
//            databaseManager.delete(item: savedArticles[indexPath.item])
//            collectionView.deleteItems(at: [indexPath])
//            savedArticles.remove(at: indexPath.item)
//            self.bookmarksView?.collectionView.reloadData()
        } else {
            databaseManager.deleteCategory(item: savedCategories[indexPath.item])
            collectionView.deleteItems(at: [indexPath])
            savedCategories.remove(at: indexPath.item)
            self.bookmarksView?.collectionView.reloadData()
        }
    }
}

extension BookmarksController: DeletionDelegate {
    func deleteArticle(indexPath: IndexPath) {
        fileManager.delete(file: savedArticles[indexPath.item].imagePath!.path)
        databaseManager.delete(item: savedArticles[indexPath.item])
        bookmarksView?.collectionView.deleteItems(at: [indexPath])
        savedArticles.remove(at: indexPath.item)
        self.bookmarksView?.collectionView.reloadData()
    }
}

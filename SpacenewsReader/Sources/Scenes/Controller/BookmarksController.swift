//
//  BookmarksController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit

class BookmarksController: UIViewController {
    
    private var savedCategories: [String] = []
    private var savedArticles: [Article] = []
    
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
            cell.configure(with: savedCategories[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            cell.configure(with: savedArticles[indexPath.item])
            cell.makeMenu(for: savedArticles[indexPath.item], viewController: self)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension BookmarksController: UICollectionViewDelegate {
    
}

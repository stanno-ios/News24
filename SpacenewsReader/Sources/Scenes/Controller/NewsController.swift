//
//  ViewController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/9/22.
//

import UIKit

class NewsController: UIViewController {
    
    let manager = NetworkManager()
    var articles: [Article] = []
    
    private var newsView: NewsView? {
        guard isViewLoaded else { return nil }
        return view as? NewsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = NewsView()
        title = Strings.title
        
        newsView?.collectionView.delegate = self
        newsView?.collectionView.dataSource = self
        manager.delegate = self
        manager.fetchArticles()
    }
}

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
            cell.configure(with: Strings.categories[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            cell.configure(with: articles[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

#warning("Implement default selected cell")
extension NewsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            let selectedCell: CategoryCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
//            selectedCell.backgroundColor = .black
//            selectedCell.label.textColor = .white
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            let cellToDeselect: CategoryCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
//            cellToDeselect.backgroundColor = .systemGray5
//            cellToDeselect.label.textColor = .gray
//        }
    }
}

extension NewsController: CategoriesDelegate {
    func updateCells(with model: [Article]) {
        DispatchQueue.main.async {
            self.articles = model
            self.newsView?.collectionView.reloadData()
        }
    }
}


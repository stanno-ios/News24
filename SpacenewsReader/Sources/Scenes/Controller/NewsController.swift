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
    var tempArticles: [Article] = []
    
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
        
        newsView?.tableView.delegate = self
        newsView?.tableView.dataSource = self
        manager.delegate = self
        manager.fetchArticles()
    }
}

extension NewsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }
}

extension NewsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 4
    }
}

extension NewsController: CategoriesDelegate {
    func updateCells(with model: [Article]) {
        DispatchQueue.main.async {
            self.articles = model
            self.tempArticles = model
            self.newsView?.tableView.reloadData()
        }
    }
    
    func applyFilter(with model: [Article]) {
        DispatchQueue.main.async {
            self.articles = model
            self.newsView?.collectionView.reloadData()
        }
    }
}


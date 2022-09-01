//
//  ReaderController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import UIKit
import WebKit

class ReaderController: UIViewController {
    
    let databaseManager = DatabaseManager()
    let fileManager = LocalStorageManager()
    
    // MARK: - Article
    
    var article: Article?
    var image: UIImage?
    var savedArticle: SavedArticle?
    
    // MARK: - Reader view
    
    private var readerView: ReaderView? {
        guard isViewLoaded else { return nil }
        return view as? ReaderView
    }
    
    deinit {
        self.readerView?.webView.removeObserver(self, forKeyPath: Strings.estimatedProgress)
        self.readerView?.webView.removeObserver(self, forKeyPath: Strings.loading)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = ReaderView()
        readerView?.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        if let article = article {
            guard let url = URL(string: article.url) else { return }
            setObservers()
            ConnectionHandler.shared.monitorConnection(views: [
                self.readerView!.noConnectionView,
                self.readerView!.webView
            ], webViewUrl: url)
            
        } else {
            guard let savedArticle = savedArticle else { return }
            guard let urlString = savedArticle.url, let url = URL(string: urlString) else { return }
            setObservers()
            ConnectionHandler.shared.monitorConnection(views: [
                self.readerView!.noConnectionView,
                self.readerView!.webView
            ], webViewUrl: url)
        }
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        readerView?.backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        readerView?.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
        readerView?.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: readerView!.backButton)
        var trailingItems: [UIBarButtonItem] = []
        if savedArticle != nil {
            trailingItems = [UIBarButtonItem(customView: readerView!.shareButton)]
        } else {
            trailingItems = [UIBarButtonItem(customView: readerView!.shareButton), UIBarButtonItem(customView: readerView!.bookmarkButton)]
        }
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItems = trailingItems
    }
    
    // MARK: - Button actions
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonTapped(sender: UIButton) {
        var itemToShare: [Any] = []
        
        if let article = article {
            itemToShare = [ArticleActivityItemSource(title: article.title, desc: article.description, url: article.url, image: image!)]
        } else if let savedArticle = savedArticle {
            itemToShare = [ArticleActivityItemSource(title: savedArticle.title!, desc: savedArticle.description, url: savedArticle.url!, image: image!)]
        }
        
        let activityVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true)
    }
    
    @objc private func bookmarkButtonTapped() {
        guard let image = self.image else { return }
        guard let article = article else { return }
        let articleToSave = DisplayableArticle(title: article.title, author: article.author, category: article.category.first!, url: article.url, description: article.description, imagePath: article.image)
        if !self.databaseManager.checkIfArticleExists(article: articleToSave) {
            self.fileManager.saveImage(image: image, title: articleToSave.title)
            self.databaseManager.saveArticle(article: articleToSave)
        } else {
            let alert = UIAlertController(title: "Oops!", message: "This article alredy exists in your bookmarks. Try another one!", preferredStyle: .alert)
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true)
            }
        }
        let alertController = UIAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        self.present(alertController, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true)
        }
    }
    
    private func setObservers() {
        self.readerView?.webView.addObserver(self, forKeyPath: Strings.loading, options: .new, context: nil)
        self.readerView?.webView.addObserver(self, forKeyPath: Strings.estimatedProgress, options: .new, context: nil)
    }
}

// MARK: - WKNavigationDelegate

extension ReaderController: WKNavigationDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.readerView?.progressIndicator.setProgress(Float((self.readerView?.webView.estimatedProgress)!), animated: true)
        } else if keyPath == "loading" {
            if self.readerView!.webView.isLoading {
                self.readerView?.progressIndicator.setProgress(0.01, animated: true)
            } else {
                self.readerView?.progressIndicator.setProgress(0.0, animated: false)
            }
        }
    }
}

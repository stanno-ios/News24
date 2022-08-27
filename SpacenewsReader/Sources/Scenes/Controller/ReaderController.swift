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
        self.readerView?.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.readerView?.webView.removeObserver(self, forKeyPath: "loading")
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
            load(url: url)
        } else {
            guard let savedArticle = savedArticle else { return }
            guard let urlString = savedArticle.url, let url = URL(string: urlString) else { return }
            setObservers()
            load(url: url)
        }
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        readerView?.backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        readerView?.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
        readerView?.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: readerView!.backButton)
        let trailingItems = [UIBarButtonItem(customView: readerView!.shareButton), UIBarButtonItem(customView: readerView!.bookmarkButton)]
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItems = trailingItems
    }
    
    // MARK: - Button actions
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonTapped(sender: UIButton) {
        guard let article = article else {
            return
        }
        let itemToShare: [Any] = [
            ArticleActivityItemSource(title: article.title, desc: article.description, url: article.url)
        ]
        let activityVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true)
    }
    
    @objc private func bookmarkButtonTapped() {
        guard let image = self.image else { return }
        guard let article = article else { return }
        let articleToSave = DisplayableArticle(title: article.title, author: article.author, category: article.category.first!, url: article.url, description: article.description, imagePath: article.image)
        self.fileManager.saveImage(image: image, title: article.title)
        self.databaseManager.saveArticle(article: articleToSave)
        
        let alertController = UIAlertController(title: Strings.alertTitle, message: Strings.alertMessage, preferredStyle: .alert)
        self.present(alertController, animated: true)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true)
        }
    }
    
    private func setObservers() {
        self.readerView?.webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.readerView?.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func load(url: URL) {
        readerView?.webView.load(URLRequest(url: url))
        readerView?.webView.allowsBackForwardNavigationGestures = true
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

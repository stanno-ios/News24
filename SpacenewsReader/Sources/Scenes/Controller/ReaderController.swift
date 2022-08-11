//
//  ReaderController.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import UIKit
import WebKit

class ReaderController: UIViewController {
    
    // MARK: - Article
    
    var article: Article?
    
    // MARK: - Reader view
    
    private var readerView: ReaderView? {
        guard isViewLoaded else { return nil }
        return view as? ReaderView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = ReaderView()
        readerView?.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = article?.url, let url = URL(string: urlString) else {
            return
        }
        readerView?.webView.load(URLRequest(url: url))
        readerView?.webView.allowsBackForwardNavigationGestures = true
        setupNavigationBar()
    }
    
    // MARK: - Private functions
    
    private func setupNavigationBar() {
        readerView?.backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        readerView?.shareButton.addTarget(self, action: #selector(shareButtonTapped(sender:)), for: .touchUpInside)
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

        let activityVC = UIActivityViewController(activityItems: [article.url], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension ReaderController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        readerView?.activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        readerView?.activityIndicator.startAnimating()
    }
}

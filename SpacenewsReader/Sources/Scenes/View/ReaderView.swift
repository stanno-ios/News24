//
//  ReaderView.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import UIKit
import WebKit

class ReaderView: UIView {
    
    var theBool: Bool?
    var timer: Timer?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - UI Elements
    
    lazy var progressIndicator: UIProgressView = {
        let progressIndicator = UIProgressView(progressViewStyle: .bar)
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.tintColor = .label
        return progressIndicator
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = .systemBackground
        return webView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var backButton: UIButton = createBarButton(with: Strings.backButtonImageName)
    lazy var bookmarkButton: UIButton = createBarButton(with: Strings.bookmarkButtonImageName)
    lazy var shareButton: UIButton = createBarButton(with: Strings.shareButtonImageName)
    
    private func createBarButton(with image: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = .label
        return button
    }
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(webView)
        webView.addSubview(activityIndicator)
        webView.addSubview(progressIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            
            progressIndicator.topAnchor.constraint(equalTo: webView.topAnchor),
            progressIndicator.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressIndicator.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressIndicator.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
}

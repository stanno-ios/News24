//
//  NewsView.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/9/22.
//

import UIKit

class NewsView: UIView {

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
    
    lazy var noConnectionView: NoConnectionView = {
        let view = NoConnectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tag = 1
        return indicator
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout.createLayout())
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(noConnectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            noConnectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noConnectionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}

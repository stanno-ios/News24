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
    
    lazy var noConnectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for network"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
//        label.isHidden = true
        return label
    }()
    
    lazy var connectingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        indicator.tag = 0
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var reconnectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = UIColor(named: "selectedButtonColor")
        button.tintColor = .label
        button.isHidden = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.tag = 1
        return indicator
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout.createLayout())
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isHidden = true
        return collectionView
    }()
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(activityIndicator)
        addSubview(noConnectionLabel)
        addSubview(connectingActivityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            noConnectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noConnectionLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            connectingActivityIndicator.leadingAnchor.constraint(equalTo: noConnectionLabel.trailingAnchor, constant: 5),
            connectingActivityIndicator.centerYAnchor.constraint(equalTo: noConnectionLabel.centerYAnchor)
        ])
    }
    
    
}

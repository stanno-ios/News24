//
//  NoConnectionView.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/31/22.
//

import UIKit

class NoConnectionView: UIView {
    
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
        label.text = Strings.noConnectionLabelText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .center
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
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(noConnectionLabel)
        addSubview(connectingActivityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            noConnectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noConnectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            connectingActivityIndicator.centerYAnchor.constraint(equalTo: noConnectionLabel.centerYAnchor),
            connectingActivityIndicator.leadingAnchor.constraint(equalTo: noConnectionLabel.trailingAnchor, constant: Metric.padding)
        ])
    }
}

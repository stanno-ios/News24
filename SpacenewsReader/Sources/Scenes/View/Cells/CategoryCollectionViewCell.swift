//
//  CategoryCollectionViewCell.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "categoryCell"
    
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
        setupView()
    }
    
    // MARK: - UI Elements
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: Metric.fontSize, weight: .medium)
        return label
    }()
    
    // MARK: - Cell selection
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        
        set {
            if super.isSelected != newValue {
                super.isSelected = newValue
                
                if newValue == true {
                    backgroundColor = .black
                    label.textColor = .white
                } else {
                    backgroundColor = .systemGray5
                    label.textColor = .gray
                }
            }
        }
    }
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(label)
    }
    
    private func setupView() {
        backgroundColor = .systemGray5
        clipsToBounds = true
        layer.cornerRadius = Metric.cornerRadius
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.padding),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with text: String) {
        self.label.text = text
    }
}

//
//  NewsCollectionViewCell.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import UIKit
import CoreData
import SDWebImage

class NewsCollectionViewCell: UICollectionViewCell {
    
    let fileManager = LocalStorageManager()
   
    // MARK: - Identifier
    
    static let identifier = "articleCell"
    
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
    
    lazy var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    lazy var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Metric.primaryFontSize, weight: .bold)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: Metric.secondaryFontSize, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "categoryColor")
        label.font = .systemFont(ofSize: Metric.secondaryFontSize, weight: .bold)
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Strings.moreButtonimageName), for: .normal)
        button.tintColor = .label
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var textContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var bottomContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Configuration
    
    private func setupHierarchy() {
        addSubview(articleImage)
        addSubview(textContainer)
        textContainer.addArrangedSubview(articleTitleLabel)
        textContainer.addArrangedSubview(authorLabel)
        textContainer.addArrangedSubview(bottomContainer)
        bottomContainer.addArrangedSubview(categoryLabel)
        bottomContainer.addArrangedSubview(moreButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: topAnchor),
            articleImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.bottomPadding),
            articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor),
            
            textContainer.topAnchor.constraint(equalTo: topAnchor),
            textContainer.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: Metric.leadingPadding),
            textContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.bottomPadding)
        ])
    }
    
    private func setupView() {
        self.layer.addBorder(edge: .bottom, color: UIColor(named: "bottomBorderColor")!, thickness: 1, widthAdjustment: 0, inset: 0)
    }
    
    func configure(with model: DisplayableArticle) {
        self.articleTitleLabel.text = model.title
        self.authorLabel.text = model.author
        self.categoryLabel.text = model.category.capitalized
        
        if model.imagePath != "None" {
            UIView.transition(with: self.articleImage, duration: 0.3, options: .curveEaseIn, animations: {
                self.articleImage.sd_setImage(with: URL(string: model.imagePath)!)
            })
        } else {
            articleImage.tintColor = .systemGray5
            articleImage.image = UIImage(systemName: Strings.defaultArticleImageName)
        }
    }
    
    func configureFromDB(with model: DisplayableArticle) {
        if FileManager.default.fileExists(atPath: model.imagePath) {
            self.articleImage.loadImageFromFilePath(path: model.imagePath)
        }
        
        self.articleTitleLabel.text = model.title
        self.authorLabel.text = model.author
        self.categoryLabel.text = model.category
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.articleImage.image = nil
        self.articleTitleLabel.text = nil
        self.authorLabel.text = nil
        self.categoryLabel.text = nil
    }
    
    func getImage() -> UIImage {
        guard let image = articleImage.image else { return UIImage(systemName: "newspaper")! }
        return image
    }
}

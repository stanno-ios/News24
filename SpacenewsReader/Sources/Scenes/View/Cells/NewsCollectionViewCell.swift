//
//  NewsCollectionViewCell.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import UIKit
import CoreData

protocol DeletionDelegate: AnyObject {
    func deleteArticle(indexPath: IndexPath)
}

class NewsCollectionViewCell: UICollectionViewCell {
    
    let fileManager = LocalStorageManager()
    let databaseManager = DatabaseManager()
    var delegate: DeletionDelegate?
    
    
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
    
    private lazy var articleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.41, green: 0.74, blue: 0.99, alpha: 1.00)
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private lazy var publishedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
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
            articleImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor),
            
            textContainer.topAnchor.constraint(equalTo: topAnchor),
            textContainer.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 10),
            textContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
    private func setupView() {
        self.layer.addBorder(edge: .bottom, color: .systemGray5, thickness: 1, widthAdjustment: 0, inset: 0)
    }
    
    func configure(with model: DisplayableArticle) {
        self.articleImage.loadImageFromUrl(urlString: model.imagePath)
        self.articleTitleLabel.text = model.title
        self.authorLabel.text = model.author
        self.categoryLabel.text = model.category
    }
    
    func configureFromDB(with model: SavedArticle) {
//        guard let article = model as? SavedArticle else { return }
//        guard let url = model.displayImage else { return }
        
        if fileManager.fileManager.fileExists(atPath: model.imagePath!.path) {
            self.articleImage.loadImageFromFilePath(path: URL(string: model.imagePath!.path)!)
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
    
    func makeMenu(for item: DisplayableArticle, viewController: UIViewController, indexPath: IndexPath? = nil) {
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { _ in
            let itemToShare: [Any] = [ArticleActivityItemSource(title: item.title, desc: item.description, url: item.url)]
            let activityVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            activityVC.popoverPresentationController?.sourceView = self.moreButton
            viewController.present(activityVC, animated: true)
        }

        let bookmarkAction = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark"), identifier: nil) { _ in
            guard let image = self.articleImage.image else { return }
            self.fileManager.saveImage(image: image, title: item.title)
            self.databaseManager.saveArticle(article: item)
            
            if !self.databaseManager.checkIfCategoryExists(category: item.category) {
                self.databaseManager.saveCategory(category: item.category)
            }
        }
        
        let deleteAction = UIAction(title: "Remove", image: UIImage(systemName: "delete.left"), identifier: nil, attributes: .destructive) { _ in
            guard let indexPath = indexPath else {
                return
            }

            self.delegate?.deleteArticle(indexPath: indexPath)
        }
        
        if viewController is BookmarksController {
            moreButton.menu = UIMenu(title: "Actions", children: [shareAction, deleteAction])
        } else {
            moreButton.menu = UIMenu(title: "Actions", children: [shareAction, bookmarkAction])
        }
    }
}

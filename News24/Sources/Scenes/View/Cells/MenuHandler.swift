//
//  MenuHandler.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/27/22.
//

import UIKit

struct MenuHandler {
    
    static private let fileManager = LocalStorageManager()
    static private let databaseManager = DatabaseManager()
    
    static var delegate: DeletionDelegate?
    
    static func makeMenu<T: UIViewController>(for cell: NewsCollectionViewCell?, with item: DisplayableArticle, viewController: T, indexPath: IndexPath? = nil) {
        guard let cell = cell else { return }
        
        if viewController.self is DeletionDelegate {
            self.delegate = viewController as? DeletionDelegate
        }
        
        let shareAction = UIAction(title: Strings.shareTitle, image: UIImage(systemName: Strings.shareImageName), identifier: nil) { _ in
            let itemToShare: [Any] = [ArticleActivityItemSource(title: item.title, desc: item.description, url: item.url, image: cell.getImage())]
            let activityVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            activityVC.popoverPresentationController?.sourceView = cell.moreButton
            viewController.present(activityVC, animated: true)
        }

        let bookmarkAction = UIAction(title: Strings.bookmarkTitle, image: UIImage(systemName: Strings.bookmarkImageName), identifier: nil) { _ in
            guard let image = cell.articleImage.image else { return }
            if !self.databaseManager.checkIfArticleExists(article: item) {
                self.fileManager.saveImage(image: image, title: item.title)
                self.databaseManager.saveArticle(article: item)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "This article alredy exists in your bookmarks. Try another one!", preferredStyle: .alert)
                viewController.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewController.dismiss(animated: true)
                }
            }
            let alertController = UIAlertController(title: ReaderController.Strings.alertTitle, message: ReaderController.Strings.alertMessage, preferredStyle: .alert)
            viewController.present(alertController, animated: true)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                viewController.dismiss(animated: true)
            }
        }
        
        let deleteAction = UIAction(title: Strings.deleteTitle, image: UIImage(systemName: Strings.deleteImageName), identifier: nil, attributes: .destructive) { _ in
            guard let indexPath = indexPath else {
                return
            }

            self.delegate?.deleteArticle(indexPath: indexPath)
        }
        
        if viewController is BookmarksController {
            cell.moreButton.menu = UIMenu(title: Strings.menuTitle, children: [shareAction, deleteAction])
        } else {
            cell.moreButton.menu = UIMenu(title: Strings.menuTitle, children: [shareAction, bookmarkAction])
        }
    }
}

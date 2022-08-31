//
//  Constants.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import UIKit

extension NewsController {
    enum Strings {
        static let categories: [String] = ["Latest", "Regional", "Technology", "Lifestyle", "Business", "General", "Programming", "Science", "Entertainment", "World", "Sports", "Finance", "Academia", "Politics", "Health", "Opinion", "Food", "Game"]
        static let title: String = "News24"
        static let defaultCategory: String = "Uncategorized"
    }
}

extension DatabaseManager {
    enum Strings {
        static let entityName: String = "SavedArticle"
        static let author: String = "author"
        static let title: String = "title"
        static let category: String = "category"
        static let imagePath: String = "imagePath"
        static let url: String = "url"
        static let desc: String = "desc"
    }
}

extension ArticleActivityItemSource {
    enum Strings {
        static let imageName: String = "newspaper"
    }
}

extension CollectionViewLayout {
    enum Metric {
        static let itemWidth: CGFloat = 100
        static let itemHeight: CGFloat = 35
        static let interGroupSpacing: CGFloat = 10
        static let contentInsets: CGFloat = 10
    }
}

extension CategoryCollectionViewCell {
    enum Metric {
        static let fontSize: CGFloat = 14
        static let cornerRadius: CGFloat = 15
        static let padding: CGFloat = 10
    }
}

extension NewsCollectionViewCell {
    enum Metric {
        static let primaryFontSize: CGFloat = 14
        static let secondaryFontSize: CGFloat = 13
        static let bottomPadding: CGFloat = 30
        static let leadingPadding: CGFloat = 10
    }
    
    enum Strings {
        static let moreButtonimageName: String = "ellipsis"
        static let defaultArticleImageName: String = "newspaper"
    }
}

extension MenuHandler {
    enum Strings {
        static let shareTitle: String = "Share"
        static let shareImageName: String = "square.and.arrow.up"
        static let bookmarkTitle: String = "Bookmark"
        static let bookmarkImageName: String = "bookmark"
        static let deleteTitle: String = "Delete"
        static let deleteImageName: String = "delete.left"
        static let menuTitle: String = "Actions"
    }
}

extension ReaderView {
    enum Strings {
        static let backButtonImageName: String = "chevron.backward"
        static let bookmarkButtonImageName: String = "bookmark"
        static let shareButtonImageName: String = "square.and.arrow.up"
    }
    
    enum Metric {
        static let progressIndicatorHeight: CGFloat = 3
    }
}

extension BookmarksView {
    enum Strings {
        static let emptyLabelText: String = "Bookmarked articles will appear here"
    }
    
    enum Metric {
        static let fontSize: CGFloat = 16
    }
}

extension ReaderController {
    enum Strings {
        static let alertTitle: String = "Bookmarked!"
        static let alertMessage: String = "This article will appear on the bookmarked tab."
        static let estimatedProgress: String = "estimatedProgress"
        static let loading: String = "loading"
    }
}

extension SearchController {
    enum Strings {
        static let placeholder: String = "Search"
    }
}

extension TabBarController {
    enum Strings {
        static let newsTabImage: String = "newspaper"
        static let searchTabImage: String = "magnifyingglass"
        static let bookmarksTabImage: String = "bookmark"
    }
}

extension BookmarksController {
    enum Strings {
        static let title: String = "Bookmarked"
    }
}

extension ConnectionHandler {
    enum Strings {
        static let queueLabel: String = "InternetConnectionMonitor"
    }
}

extension NoConnectionView {
    enum Strings {
        static let noConnectionLabelText: String = "Waiting for network"
    }
    
    enum Metric {
        static let padding: CGFloat = 5
    }
}

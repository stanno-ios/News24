//
//  ArticleActivityItemSource.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit
import LinkPresentation

/// class ArticleActivityItemSource represents a share item

class ArticleActivityItemSource: NSObject, UIActivityItemSource {
    
    var title: String
    var desc: String
    var url: String
    var image: UIImage
    
    init(title: String, desc: String, url: String, image: UIImage) {
        self.title = title
        self.desc = desc
        self.url = url
        self.image = image
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return desc
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return URL(string: url)!
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: image)
        metadata.originalURL = URL(string: url)
        return metadata
    }
}

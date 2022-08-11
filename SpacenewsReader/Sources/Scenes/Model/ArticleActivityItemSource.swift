//
//  ArticleActivityItemSource.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/11/22.
//

import UIKit
import LinkPresentation

class ArticleActivityItemSource: NSObject, UIActivityItemSource {
    
    var title: String
    var desc: String
    var url: String
    
    init(title: String, desc: String, url: String) {
        self.title = title
        self.desc = desc
        self.url = url
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return desc
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "newspaper")!)
        metadata.originalURL = URL(string: url)
        return metadata
    }
}

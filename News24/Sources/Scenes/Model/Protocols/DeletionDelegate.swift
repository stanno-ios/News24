//
//  DeletionDelegate.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/27/22.
//

import UIKit

protocol DeletionDelegate: AnyObject {
    func deleteArticle(indexPath: IndexPath)
}

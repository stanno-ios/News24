//
//  Categories.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import CoreData

protocol Displayable {
    var displayTitle: String { get }
    var displayAuthor: String { get }
    var displayCategory: String { get }
    var displayImage: String { get }
    var displayURL: String { get }
}

struct News: Decodable {
    let status: String
    let news: [Article]
    let page: Int
}

struct Article: Decodable {
    let id: String
    let title: String
    let description: String
    let url: String
    let author: String
    let image: String
    let language: String
    let category: [String]
    let published: String
}

extension Article: Displayable {
    var displayTitle: String {
        title
    }
    
    var displayAuthor: String {
        author
    }
    
    var displayCategory: String {
        category[0]
    }
    
    var displayImage: String {
        image
    }
    
    var displayURL: String {
        url
    }
    
    
}



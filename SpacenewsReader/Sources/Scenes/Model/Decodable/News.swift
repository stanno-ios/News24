//
//  Categories.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import CoreData

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



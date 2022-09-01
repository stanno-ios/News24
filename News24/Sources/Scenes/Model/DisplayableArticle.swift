//
//  DisplayableArticle.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/19/22.
//

import Foundation

/// struct DisplayableArticle is created as a more generic approach to handle article display from different sources

struct DisplayableArticle {
    let title: String
    let author: String
    let category: String
    let url: String
    let description: String
    let imagePath: String
}

//
//  Categories.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation

struct News: Decodable {
    let categories: [String]
    let description: String
    let status: String
}


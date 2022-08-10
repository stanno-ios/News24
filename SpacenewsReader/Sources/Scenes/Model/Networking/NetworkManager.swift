//
//  NetworkManager.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import Alamofire

protocol CategoriesDelegate {
    func updateCells(with model: [Article])
}

class NetworkManager {
    
    var delegate: CategoriesDelegate?
    
    func fetchArticles() {
        AF.request("https://api.currentsapi.services/v1/latest-news?apiKey=TeSfqsIS6rmfl2atTPhnfpunLLr25eV8ReABx-uZ3X8Aoj0w")
            .validate()
            .responseDecodable(of: News.self) { (data) in
                guard let response = data.value else { return }
                let articles = response.news
                self.delegate?.updateCells(with: articles)
        }
       
    }
}

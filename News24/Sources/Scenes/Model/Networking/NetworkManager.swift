//
//  NetworkManager.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import Alamofire

/// class NetworkManager is responsible for handling API calls

class NetworkManager {
    
    static let shared = NetworkManager()
    var delegate: CategoriesDelegate?
    var searchDelegate: SearchDelegate?
    
    func fetchArticles() {
        let url = "https://api.currentsapi.services/v1/latest-news"
        let parameters: [String: String] = ["apiKey": "TeSfqsIS6rmfl2atTPhnfpunLLr25eV8ReABx-uZ3X8Aoj0w"]
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: News.self) { (data) in
                guard let response = data.value else { return }
                let articles = response.news
                self.delegate?.updateCells(with: articles)
        }
    }
    
    func applyFilter(category: String) {
        let url = "https://api.currentsapi.services/v1/search"
        let parameters: [String: String] = ["category": category, "apiKey": "TeSfqsIS6rmfl2atTPhnfpunLLr25eV8ReABx-uZ3X8Aoj0w"]
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: News.self) { (data) in
                guard let response = data.value else { return }
                let articles = response.news
                self.delegate?.reloadFiltered(with: articles)
            }
    }
    
    func searchByKeywords(keywords: String) {
        let url = "https://api.currentsapi.services/v1/search"
        let parameters: [String: String] = ["keywords": keywords, "apiKey": "TeSfqsIS6rmfl2atTPhnfpunLLr25eV8ReABx-uZ3X8Aoj0w"]
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: News.self) { (data) in
                guard let response = data.value else { return }
                let articles = response.news
                self.searchDelegate?.updateSearchResults(with: articles)
            }
    }
}

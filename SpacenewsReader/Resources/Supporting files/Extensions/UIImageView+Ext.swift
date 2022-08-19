//
//  UIImageView+Ext.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/10/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func loadImageFromFilePath(path: URL) {
//        DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: path) {
            if let image = UIImage(data: data) {
//                DispatchQueue.main.async {
                    self.image = image
//                }
//            }
        }
        }
            
    }
}

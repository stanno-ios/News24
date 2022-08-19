//
//  LocalStorageManager.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/12/22.
//

import Foundation
import UIKit

class LocalStorageManager {
    let fileManager = FileManager.default
    
    var documentsUrl: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func saveImage(image: UIImage, title: String) {
        let filename = documentsUrl.appendingPathComponent("\(title.trimmingCharacters(in: .whitespaces))")
        try? image.pngData()?.write(to: filename, options: .atomic)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getFileURL(title: String) -> URL {
        return documentsUrl.appendingPathComponent("\(title.trimmingCharacters(in: .whitespaces))")
    }
    
    func delete(file: String) {
        guard let url = URL(string: file) else { return }
        try? fileManager.removeItem(at: url)
        print("Removed")
    }
}

//
//  DatabaseManager.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/12/22.
//

import UIKit
import CoreData

///  class DatabaseManager is responsible for CoreData CRUD actions

class DatabaseManager {
    
    let fileManager = LocalStorageManager()
    
    func saveArticle(article: DisplayableArticle) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: Strings.entityName, in: context)
        guard let entity = entity else {
            return
        }

        let savedArticle = NSManagedObject(entity: entity, insertInto: context)
        
        savedArticle.setValuesForKeys([Strings.author: article.author,
                                       Strings.title: article.title,
                                       Strings.category: article.category,
                                       Strings.imagePath: fileManager.getFileURL(title: article.title) as Any,
                                       Strings.url: article.url,
                                       Strings.desc: article.description])
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchData() -> [SavedArticle]? {
        var articles: [SavedArticle]?
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Strings.entityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            articles = results as? [SavedArticle]
        } catch let error as NSError {
            print(error)
        }
        
        return articles
    }
    
    func delete(item: SavedArticle) {
        let context = getContext()
        context.delete(item)
        saveContext(context: context)
    }
    
    func deleteCategory(item: SavedCategory) {
        let context = getContext()
        context.delete(item)
        saveContext(context: context)
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.persistentContainer.viewContext
    }
}

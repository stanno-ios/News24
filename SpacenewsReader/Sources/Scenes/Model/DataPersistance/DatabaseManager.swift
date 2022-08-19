//
//  DatabaseManager.swift
//  SpacenewsReader
//
//  Created by Stanislav Rassolenko on 8/12/22.
//

import UIKit
import CoreData

protocol DatabaseDelegate: AnyObject {
    func reload()
}

class DatabaseManager {
    let fileManager = LocalStorageManager()
    
    var delegate: DatabaseDelegate?
    
    func saveArticle(article: DisplayableArticle) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SavedArticle", in: context)
        guard let entity = entity else {
            return
        }

        let savedArticle = NSManagedObject(entity: entity, insertInto: context)
        
        savedArticle.setValuesForKeys(["author": article.author,
                                       "title": article.title,
                                       "category": article.category,
                                       "imagePath": URL(string: article.imagePath) as Any,
                                       "url": article.url,
                                       "desc": article.description])
//        savedArticle.title = article.displayTitle
//        savedArticle.author = article.displayAuthor
//        savedArticle.imagePath = URL(string: article.displayImage)
//        savedArticle.url = article.displayURL
//        savedArticle.category = article.displayCategory
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveCategory(category: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SavedCategory", in: context)!
        let savedArticle = NSManagedObject(entity: entity, insertInto: context)
        savedArticle.setValue(category, forKey: "category")
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchCategories() -> [SavedCategory]? {
        var categories: [NSManagedObject]?
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedCategory")
        
        do {
            categories = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        return categories as? [SavedCategory]
    }
    
    func fetchData() -> [SavedArticle]? {
        var articles: [SavedArticle]?
        let context = getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArticle")
        
        
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
    
    func checkIfCategoryExists(category: String) -> Bool {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedCategory")
        fetchRequest.predicate = NSPredicate(format: "category = %@", category)
        var results: [NSManagedObject] = []
        do {
            results = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        return results.count > 0
    }
    
    func deleteAllData(entity: String)
    {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

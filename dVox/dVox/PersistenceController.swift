//
//  PersistenceController.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/17/21.
//

import CoreData
import SwiftUI

class PersistenceController {
    
    static let shared = PersistenceController()
    
    private static var persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "SavedPosts")
                container.loadPersistentStores { description, error in
                    if let error = error {
                         fatalError("Unable to load persistent stores: \(error)")
                    }
                }
                return container
            }()
    
    
    var context: NSManagedObjectContext {
           return Self.persistentContainer.viewContext
       }
    
    init(){
    }
    
    
    func savePost(post: Post){
    
        let item = Item(context: context)
        
        item.postId = Int64(post.id)
        item.author = post.author
        item.title = post.title
        item.message = post.message
        item.hashtag = post.hashtag
        item.upVotes = Int64(post.upVotes)
        item.downVotes = Int64(post.downVotes)
        item.commentsNumber = Int64(post.commentsNumber)
        item.ban = post.ban
        
        PersistenceController.shared.save()
        
    }

    func deleteAllItems() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for item in results {
                context.delete(item)
            }
        } catch let error {
            print("Error while deleting all saved posts: \(error) Check Persistence Controller.")
        }
    }
    
    func getallItems() -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error while retrieving all saved posts: \(error) Check Persistence Controller.")
            return []
        }
    }
    
    
    func save(completion: @escaping (Error?) -> () = {_ in}) {
            do {
                try context.save()
                completion(nil)
            } catch {
                print("Error while saving posts: \(error) Check Persistence Controller.")
                completion(error)
            }
        
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        context.delete(object)
        save(completion: completion)
    }
}

//
//  PersistenceController.swift
//  dVox
//
//  Created by Aleksandr Molchagin on 8/17/21.
//

import CoreData
import SwiftUI

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "SavedPosts")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func save(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                print("SAVING")
                try context.save()
                completion(nil)
            } catch {
                print("ERROR")
                completion(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}

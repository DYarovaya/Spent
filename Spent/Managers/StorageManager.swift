//
//  StorageManager.swift
//  Spent
//
//  Created by Дарья Яровая on 20.07.2021.
//

import UIKit
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private var viewContext: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchAllData() -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
             return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []        }
    }
    
    func fetchDataByDay(day: String) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "date like %@", day
        )
        do {
             return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []        }
    }
    
    func save(date: String, time: String, amount: String, comment: String = "") {
        let transaction = Transaction(context: viewContext)
        transaction.amount = amount
        transaction.date = date
        transaction.time = time
        transaction.comment = comment
        
        //completion(transaction)
        saveContext()
    }
    
    func delete(_ transaction: Transaction) {
        viewContext.delete(transaction)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

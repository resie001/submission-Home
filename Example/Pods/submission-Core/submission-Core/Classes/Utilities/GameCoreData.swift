//
//  GameCoreData.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import CoreData

public class GameCoreData {
    public static let shared = GameCoreData()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public func saveContext() {
        let context = GameCoreData.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                if let error = error as NSError? {
                    debugPrint(error, "Save Context Error")
                }
            }
        }
    }
    
    func searchFavorite(query: String) async -> ([GameResponse], Bool, String?) {
        await withCheckedContinuation { continuation in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                var games = [GameResponse]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
                do {
                    let results = try context.fetch(fetchRequest)
                    for result in results {
                        let game = GameResponse()
                        game.id = result.value(forKeyPath: "id") as? Float
                        game.name = result.value(forKeyPath: "name") as? String
                        game.release = result.value(forKeyPath: "releaseDate") as? String
                        game.backgroundImage = result.value(forKeyPath: "backgroundImage") as? String
                        game.rating = result.value(forKeyPath: "rating") as? Float
                        games.append(game)
                    }
                    continuation.resume(returning: (games, true, nil))
                } catch let error as NSError {
                    continuation.resume(returning: ([], false, error.localizedDescription))
                }
            }
        }
    }
    
    func searchFavorite(query: String) async -> ([GameEntity], Bool, String?) {
        await withCheckedContinuation { continuation in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                var games = [GameEntity]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
                do {
                    let results = try context.fetch(fetchRequest)
                    for result in results {
                        let game = GameEntity(
                            id: result.value(forKeyPath: "id") as! Float,
                            name: result.value(forKeyPath: "name") as! String,
                            release: result.value(forKeyPath: "releaseDate") as! String,
                            backgroundImage: result.value(forKeyPath: "backgroundImage") as! String,
                            rating: result.value(forKeyPath: "rating") as! Float
                        )
                        games.append(game)
                    }
                    continuation.resume(returning: (games, true, nil))
                } catch let error as NSError {
                    continuation.resume(returning: ([], false, error.localizedDescription))
                }
            }
        }
    }
    
    public func checkFavorite(id: Float) async -> (Bool) {
        await withCheckedContinuation { continuation in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
            fetchRequest.predicate = NSPredicate(format: "id = %f", id)
            
            var results: [NSManagedObject] = []
            
            do {
                results = try GameCoreData.shared.persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                debugPrint("error executing fetch request: \(error)")
            }
            continuation.resume(returning: (results.count > 0))
        }
    }
    
    func getAllFavorites() async -> ([GameResponse], Bool, String?) {
        await withCheckedContinuation { continuation in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                var games = [GameResponse]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                do {
                    let results = try context.fetch(fetchRequest)
                    for result in results {
                        let game = GameResponse()
                        game.id = result.value(forKeyPath: "id") as? Float
                        game.name = result.value(forKeyPath: "name") as? String
                        game.release = result.value(forKeyPath: "releaseDate") as? String
                        game.backgroundImage = result.value(forKeyPath: "backgroundImage") as? String
                        game.rating = result.value(forKeyPath: "rating") as? Float
                        games.append(game)
                    }
                    continuation.resume(returning: (games, true, nil))
                } catch let error as NSError {
                    continuation.resume(returning: ([], false, error.localizedDescription))
                }
            }
        }
    }
    
    func unFavorited(id: Float) async -> Bool {
        await withCheckedContinuation { continuation in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                fetchRequest.fetchLimit = 1
                if let result = try? context.fetch(fetchRequest), let member = result.first {
                    context.delete(member)
                    do {
                        try context.save()
                        continuation.resume(returning: true)
                    } catch let error as NSError {
                        debugPrint(error.localizedDescription)
                        continuation.resume(returning: false)
                    }
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    func favorited(game: GameResponse) async -> Bool {
        await withCheckedContinuation { continuation in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                if let entity = NSEntityDescription.entity(forEntityName: "GameCore", in: context) {
                    let member = NSManagedObject(entity: entity, insertInto: context)
                    member.setValue(game.id!, forKey: "id")
                    member.setValue(game.backgroundImage!, forKey: "backgroundImage")
                    member.setValue(game.name!, forKey: "name")
                    member.setValue(game.rating!, forKey: "rating")
                    member.setValue(game.release!, forKey: "releaseDate")
                    do {
                        try context.save()
                        continuation.resume(returning: true)
                    } catch let error as NSError {
                        debugPrint(error.localizedDescription)
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
}

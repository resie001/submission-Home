//
//  LocalDataSource.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import CoreData
import RxSwift

protocol LocalDataSourceProtocol {
    func searchFavorite(query: String) -> Observable<[GameEntity]>
    func checkFavorite(id: Float) -> Observable<Bool>
    func getAllFavorites() -> Observable<[GameEntity]>
    func unFavorited(id: Float) -> Observable<Bool>
    func favorited(game: GameModel) -> Observable<Bool>
}

class LocalDataSource: NSObject {
    private override init() { }
    
    static let shared =  LocalDataSource()
}

extension LocalDataSource: LocalDataSourceProtocol {
    func searchFavorite(query: String) -> Observable<[GameEntity]> {
        return Observable<[GameEntity]>.create { observer in
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
                            rating: result.value(forKeyPath: "rating") as! Float)
                        games.append(game)
                    }
                    observer.onNext(games)
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func checkFavorite(id: Float) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
            fetchRequest.predicate = NSPredicate(format: "id = %f", id)
            
            var results: [NSManagedObject] = []
            
            do {
                results = try GameCoreData.shared.persistentContainer.viewContext.fetch(fetchRequest)
            } catch {
                debugPrint("error executing fetch request: \(error)")
            }
            observer.onNext(results.count > 0)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func getAllFavorites() -> Observable<[GameEntity]> {
        return Observable<[GameEntity]>.create { observer in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                var games = [GameEntity]()
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                do {
                    let results = try context.fetch(fetchRequest)
                    for result in results {
                        let game = GameEntity(
                            id: result.value(forKeyPath: "id") as! Float,
                            name: result.value(forKeyPath: "name") as! String,
                            release: result.value(forKeyPath: "releaseDate") as! String,
                            backgroundImage: result.value(forKeyPath: "backgroundImage") as! String,
                            rating: result.value(forKeyPath: "rating") as! Float)
                        games.append(game)
                    }
                    observer.onNext(games)
                    observer.onCompleted()
                } catch let error as NSError {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func unFavorited(id: Float) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameCore")
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                fetchRequest.fetchLimit = 1
                if let result = try? context.fetch(fetchRequest), let member = result.first {
                    context.delete(member)
                    do {
                        try context.save()
                        observer.onNext(true)
                        observer.onCompleted()
                    } catch let error as NSError {
                        observer.onError(error)
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func favorited(game: GameModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let context = GameCoreData.shared.persistentContainer.newBackgroundContext()
            context.perform {
                if let entity = NSEntityDescription.entity(forEntityName: "GameCore", in: context) {
                    let member = NSManagedObject(entity: entity, insertInto: context)
                    member.setValue(game.id, forKey: "id")
                    member.setValue(game.backgroundImage, forKey: "backgroundImage")
                    member.setValue(game.name, forKey: "name")
                    member.setValue(game.rating, forKey: "rating")
                    member.setValue(game.release, forKey: "releaseDate")
                    do {
                        try context.save()
                        observer.onNext(true)
                        observer.onCompleted()
                    } catch let error as NSError {
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
}

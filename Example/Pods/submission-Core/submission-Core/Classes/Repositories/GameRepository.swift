//
//  GameRepository.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import Alamofire
import RxSwift

public protocol GameRepositoryProtocol {
    // MARK: Local Repository
    func searchFavorite(query: String) -> Observable<[GameEntity]>
    func checkFavorite(id: Float) -> Observable<Bool>
    func getAllFavorites() -> Observable<[GameEntity]>
    func unFavorited(id: Float) -> Observable<Bool>
    func favorited(game: GameModel) -> Observable<Bool>
    
    // MARK: Remote Repository
    func fetchGames(page: Int) -> Observable<GamesResponse?>
    func search(query: String, page: Int) -> Observable<GamesResponse?>
    func fetchGameDetail(id: Float) -> Observable<GameResponse?>
}

final class GameRepository {
    typealias GameInstance = (LocalDataSource, RemoteDataSource) -> GameRepository
    
    fileprivate let remote: RemoteDataSource
    fileprivate let locale: LocalDataSource
    
    private init(locale: LocalDataSource, remote: RemoteDataSource) {
        self.locale = locale
        self.remote = remote
    }
    
    static let sharedInstance: GameInstance = { localeRepo, remoteRepo in
        return GameRepository(locale: localeRepo, remote: remoteRepo)
    }
}

extension GameRepository: GameRepositoryProtocol {
    func searchFavorite(query: String) -> Observable<[GameEntity]> {
        return self.locale.searchFavorite(query: query)
    }
    
    func checkFavorite(id: Float) -> Observable<Bool> {
        return self.locale.checkFavorite(id: id)
    }
    
    func getAllFavorites() -> Observable<[GameEntity]> {
        return self.locale.getAllFavorites()
    }
    
    func unFavorited(id: Float) -> Observable<Bool> {
        return self.locale.unFavorited(id: id)
    }
    
    func favorited(game: GameModel) -> Observable<Bool> {
        return self.locale.favorited(game: game)
    }
    
    func fetchGames(page: Int) -> Observable<GamesResponse?> {
        return self.remote.fetchGames(page: page)
    }
    
    func search(query: String, page: Int) -> Observable<GamesResponse?> {
        return self.remote.search(query: query, page: page)
    }
    
    func fetchGameDetail(id: Float) -> Observable<GameResponse?> {
        return self.remote.fetchGameDetail(id: id)
    }
}

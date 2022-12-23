//
//  HomeProtocols.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import UIKit
import submission_Core

protocol HomePresenterToRouterProtocol: AnyObject {
    static func createModule(type: List, delegate: HomeDelegate) -> UIViewController
}

protocol HomeViewToPresenterProtocol: AnyObject {
    var router: HomePresenterToRouterProtocol? {get set}
    var view: HomePresenterToViewProtocol? {get set}
    var interactor: HomePresenterToInteractorProtocol? {get set}
    var state: UIState {get set}
    var games: [GameModel] {get set}
    var isNextExist: Bool {get set}
    var type: List! {get set}
    
    func fetchGames(isReload: Bool)
    func fetchFavorites()
    func searchFavorites(query: String)
    func searchGames(query: String)
    func favorite(game: GameModel)
}

protocol HomePresenterToInteractorProtocol: AnyObject {
    var presenter: HomeInteractorToPresenterProtocol? {get set}
    var repository: GameRepositoryProtocol? {get set}
    func fetchGames(isReload: Bool)
    func fetchFavorites()
    func search(query: String)
    func searchFavorites(query: String)
    func addFavorite(game: GameModel)
}

protocol HomeInteractorToPresenterProtocol: AnyObject {
    func gameResult(games: GamesResponse?, isSuccess: Bool, message: String?, isReload: Bool)
    func searchResult(games: GamesResponse?, isSuccess: Bool, message: String?)
    func favoriteResult(games: [GameEntity], isSuccess: Bool, message: String?)
    func favoriteSearchResult(games: [GameEntity], isSuccess: Bool, message: String?)
    func favoritedResult()
}

protocol HomePresenterToViewProtocol: BasicViewProtocols {
    func showGame()
    func showSearchResult()
    func showFavorites()
    func showFavoriteSearchResult()
    func failed(message: String)
    func favoritedResult()
}

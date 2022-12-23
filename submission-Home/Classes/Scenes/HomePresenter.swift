//
//  HomePresenter.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import submission_Core

class HomePresenter: HomeViewToPresenterProtocol {
    var router: HomePresenterToRouterProtocol?
    var view: HomePresenterToViewProtocol?
    var interactor: HomePresenterToInteractorProtocol?
    
    var state: UIState = .initial
    var games: [GameModel] = []
    var isNextExist: Bool = true
    var type: List!
    
    func fetchGames(isReload: Bool) {
        interactor?.fetchGames(isReload: isReload)
    }

    func searchGames(query: String) {
        interactor?.search(query: query)
    }
    
    func fetchFavorites() {
        interactor?.fetchFavorites()
    }
    
    func searchFavorites(query: String) {
        interactor?.searchFavorites(query: query)
    }
    
    func favorite(game: GameModel) {
        interactor?.addFavorite(game: game)
    }
}

extension HomePresenter: HomeInteractorToPresenterProtocol {
    func gameResult(games: GamesResponse?, isSuccess: Bool, message: String?, isReload: Bool) {
        if isSuccess {
            isNextExist = games?.isNextExist ?? false
            if isReload {
                self.games = games?.games.map { GameMapper.mapGameResponsesToModel(input: $0) } ?? []
            } else {
                self.games.append(contentsOf: games?.games.map { GameMapper.mapGameResponsesToModel(input: $0) } ?? [])
            }
            state = self.games.isEmpty ? .empty : .finish
            view?.showGame()
        } else {
            state = .failed
            view?.failed(message: message ?? "")
        }
    }
    
    func searchResult(games: GamesResponse?, isSuccess: Bool, message: String?) {
        if isSuccess {
            self.games = games?.games.map { GameMapper.mapGameResponsesToModel(input: $0) } ?? []
            state = self.games.isEmpty ? .empty : .finish
            view?.showSearchResult()
        } else {
            state = .failed
            view?.failed(message: message ?? "")
        }
    }
    
    func favoriteResult(games: [GameEntity], isSuccess: Bool, message: String?) {
        if isSuccess {
            self.games = GameMapper.mapGameEntityToModel(input: games)
            state = self.games.isEmpty ? .empty : .finish
            view?.showFavorites()
        } else {
            state = .failed
            view?.failed(message: message ?? "")
        }
    }
    
    func favoriteSearchResult(games: [GameEntity], isSuccess: Bool, message: String?) {
        if isSuccess {
            self.games = GameMapper.mapGameEntityToModel(input: games)
            state = self.games.isEmpty ? .empty : .finish
            view?.showFavoriteSearchResult()
        } else {
            state = .failed
            view?.failed(message: message ?? "")
        }
    }
    
    func favoritedResult() {
        view?.favoritedResult()
    }
}

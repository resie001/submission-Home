//
//  HomeInteractor.swift
//  submission-Home
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import RxSwift
import submission_Core

class HomeInteractor: HomePresenterToInteractorProtocol {
    private let disposeBag = DisposeBag()
    private var page = 1
    var presenter: HomeInteractorToPresenterProtocol?
    var repository: GameRepositoryProtocol?
    private let url = Constants.BaseUrl + "games"
    
    func fetchFavorites() {
        repository?.getAllFavorites()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.presenter?.favoriteResult(games: result, isSuccess: true, message: nil)
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.presenter?.favoriteResult(games: [], isSuccess: false, message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func addFavorite(game: GameModel) {
        repository?.checkFavorite(id: game.id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.repository?.unFavorited(id: game.id)
                        .observe(on: MainScheduler.instance)
                        .subscribe { [weak self] _ in
                            guard let self = self else { return }
                            self.presenter?.favoritedResult()
                        }
                        .disposed(by: self.disposeBag)
                } else {
                    self.repository?.favorited(game: game)
                        .observe(on: MainScheduler.instance)
                        .subscribe { [weak self] _ in
                            guard let self = self else { return }
                            self.presenter?.favoritedResult()
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func searchFavorites(query: String) {
        repository?.searchFavorite(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.presenter?.favoriteSearchResult(games: result, isSuccess: true, message: nil)
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.presenter?.favoriteSearchResult(games: [], isSuccess: false, message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchGames(isReload: Bool) {
        if isReload {
            page = 1
        }
        repository?.fetchGames(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.page+=1
                self.presenter?.gameResult(games: result, isSuccess: true, message: nil, isReload: isReload)
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.presenter?.gameResult(
                    games: nil, isSuccess: false, message: error.localizedDescription, isReload: isReload
                )
            }
            .disposed(by: disposeBag)
    }
    
    func search(query: String) {
        repository?.search(query: query, page: page)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                self.page+=1
                self.presenter?.searchResult(games: result, isSuccess: true, message: nil)
            } onError: { [weak self] error in
                guard let self = self else { return }
                self.presenter?.searchResult(games: nil, isSuccess: false, message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

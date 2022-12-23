//
//  RemoteDataSource.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

protocol RemoteDataSourceProtocol {
    func fetchGames(page: Int) -> Observable<GamesResponse?>
    func search(query: String, page: Int) -> Observable<GamesResponse?>
    func fetchGameDetail(id: Float) -> Observable<GameResponse?>
}

class RemoteDataSource: NSObject {
    private override init() { }
    
    static let shared =  RemoteDataSource()
    private let url = Constants.BaseUrl + "games"
}

extension RemoteDataSource: RemoteDataSourceProtocol {
    func fetchGames(page: Int) -> Observable<GamesResponse?> {
        return Observable<GamesResponse?>.create { observer in
            let parameters: Parameters = [
                "page_size": 20,
                "key": Constants.key,
                "page": page
            ]
            AF.request(self.url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let data):
                        let game = Mapper<GamesResponse>().map(JSONString: data)
                        observer.onNext(game)
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
    }
    
    func search(query: String, page: Int) -> Observable<GamesResponse?> {
        return Observable<GamesResponse?>.create { observer in
            let parameters: Parameters = [
                "page_size": 20,
                "key": Constants.key,
                "page": page,
                "search": query
            ]
            AF.request(self.url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let data):
                        let game = Mapper<GamesResponse>().map(JSONString: data)
                        observer.onNext(game)
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchGameDetail(id: Float) -> Observable<GameResponse?> {
        return Observable<GameResponse?>.create { observer in
            let parameters: Parameters = [
                "key": Constants.key
            ]
            AF.request(self.url + "/\(Int(id))", method: .get, parameters: parameters, encoding: URLEncoding.default)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let data):
                        let game = Mapper<GameResponse>().map(JSONString: data)
                        observer.onNext(game)
                        observer.onCompleted()
                    case .failure(let err):
                        observer.onError(err)
                    }
                }
            return Disposables.create()
        }
    }
}

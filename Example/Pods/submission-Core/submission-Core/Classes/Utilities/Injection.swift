//
//  Injection.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation

public final class Injection {
    static private let shared = Injection()
    static private var instance: GameRepositoryProtocol?
    
    public static func getInstance() -> GameRepositoryProtocol {
        if instance == nil {
            instance = shared.provideRepository()
        }
        return instance!
    }
    
    private func provideRepository() -> GameRepositoryProtocol {
        let locale = LocalDataSource.shared
        let remote = RemoteDataSource.shared
        return GameRepository.sharedInstance(locale, remote)
    }
}

//
//  Mapper.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation

public final class GameMapper {
    public static func mapGameResponsesToModel(
        input gameResponses: [GameResponse]
    ) -> [GameModel] {
        return gameResponses.map { result in
            let newCategory = GameModel(
                id: result.id ?? 0.0,
                name: result.name ?? "",
                release: result.release ?? "",
                backgroundImage: result.backgroundImage ?? "",
                rating: result.rating ?? 0.0)
            return newCategory
        }
    }
    
    public static func mapGameEntityToModel(
        input gameEntities: [GameEntity]
    ) -> [GameModel] {
        return gameEntities.map { result in
            let newCategory = GameModel(
                id: result.id,
                name: result.name,
                release: result.release,
                backgroundImage: result.backgroundImage,
                rating: result.rating)
            return newCategory
        }
    }
    
    public static func mapGameResponseToDetailModel(
        input gameResponse: GameResponse
    ) -> GameDetailModel {
        return GameDetailModel(
            id: gameResponse.id ?? 0.0,
            name: gameResponse.name ?? "",
            release: gameResponse.release ?? "",
            backgroundImage: gameResponse.backgroundImage ?? "",
            rating: gameResponse.rating ?? 0.0,
            desc: gameResponse.desc ?? "",
            metacritic: gameResponse.metacritic ?? 0
        )
    }
}

//
//  GameModel.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation

public struct GameModel {
    public var id: Float
    public var name: String
    public var release: String
    public var backgroundImage: String
    public var rating: Float
}

public struct GameDetailModel {
    public var id: Float
    public var name: String
    public var release: String
    public var backgroundImage: String
    public var rating: Float
    public var desc: String
    public var metacritic: Int
}

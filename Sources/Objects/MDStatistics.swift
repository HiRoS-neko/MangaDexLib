//
//  MDStatistics.swift
//  MangaDexLib
//
//  Created by Kyle Giammarco on 2023-07-05.
//  Copyright © 2023 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a statistc returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDStatistic: Decodable {
    public let comments: MDComment?

    public let raing: MDRating?

    public let follows: Int?
}

public struct MDComment: Decodable {
    public let threadId: Int
    public let repliesCount: Int
}

public struct MDRating: Decodable {
    public let average: Float
    public let bayesian: Float
    public let distribution: MDDistribution
}

public struct MDDistribution: Decodable {
    public let One: Int
    public let Two: Int
    public let Three: Int
    public let Four: Int
    public let Five: Int
    public let Six: Int
    public let Seven: Int
    public let Eight: Int
    public let Nine: Int
    public let Ten: Int
}

public extension MDDistribution {
    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case One = "1"
        case Two = "2"
        case Three = "3"
        case Four = "4"
        case Five = "5"
        case Six = "6"
        case Seven = "7"
        case Eight = "8"
        case Nine = "9"
        case Ten = "10"
    }
}

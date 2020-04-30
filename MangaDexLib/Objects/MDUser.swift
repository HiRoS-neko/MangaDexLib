//
//  MDUser.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Class representing a user returned by MangaDex
public struct MDUser {

    /// The id of the chapter
    public var userId: Int

    /// The user's display name
    public var name: String?

    /// The user's rank
    public var rank: MDRank?

    /// The user's avatar URL
    public var avatar: String?

    /// A convenience method to create a user with only an id
    init(userId: Int) {
        self.userId = userId
    }

    /// A convenience method to create a user with a name and id only
    init(name: String, userId: Int) {
        self.name = name
        self.userId = userId
    }

}

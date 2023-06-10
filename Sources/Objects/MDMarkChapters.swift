//
//  MDMarkChapters.swift
//  MangaDexLib
//
//  Created by Kyle Giammarco on 2023-06-10.
//  Copyright © 2023 JustKodding. All rights reserved.
//

import Foundation

/// Structure to store read and unread ids when attempting to mark as read/unread
public struct MDMarkChapters: Encodable {
    /// The read chapters
    public let chapterIdsRead: [String]

    /// The unread chapters
    public let chapterIdsUnread: [String]

    
    public init(chapterIdsRead: [String], chapterIdsUnread: [String]) {
        self.chapterIdsRead = chapterIdsRead
        self.chapterIdsUnread = chapterIdsUnread
    }
}

extension MDMarkChapters {

    /// Coding keys to encode our struct as JSON data
    enum CodingKeys: String, CodingKey {
        case chapterIdsRead
        case chapterIdsUnread
    }

}

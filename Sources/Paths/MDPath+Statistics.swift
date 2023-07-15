//
//  MDPath+Statistics.swift
//  MangaDexLib
//
//  Created by Kyle Giammarco on 2023-07-15.
//  Copyright © 2023 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {
    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func chapterStatistics(chapterId: String) -> URL {
        return buildUrl(for: .statistics, with: ["chapter", chapterId])
    }

    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func chaptersStatistics(chapterIds: [String]) -> URL {
        let params = MDPath.formatQueryItem(name: "chapter", array: chapterIds)
        return buildUrl(for: .statistics, with: ["chapter"])
    }

    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func groupStatistics(groupId: String) -> URL {
        return buildUrl(for: .statistics, with: ["group", groupId])
    }

    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func groupsStatistics(groupIds: [String]) -> URL {
        let params = MDPath.formatQueryItem(name: "group", array: groupIds)
        return buildUrl(for: .statistics, with: ["group"])
    }

    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func mangaStatistics(mangaId: String) -> URL {
        return buildUrl(for: .statistics, with: ["manga", mangaId])
    }

    /// Build the URL to get the statistics of a chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Returns: The MangaDex URL
    static func mangasStatistics(mangaIds: [String]) -> URL {
        let params = MDPath.formatQueryItem(name: "manga", array: mangaIds)
        return buildUrl(for: .statistics, with: ["manga"])
    }
}

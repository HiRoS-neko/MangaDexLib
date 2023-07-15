//
//  MDApi+Statistics.swift
//  MangaDexLib
//
//  Created by Kyle Giammarco on 2023-07-05.
//  Copyright © 2023 JustKodding. All rights reserved.
//

import Foundation

public extension MDApi
{
    func getChapterStatistics(chapterId: String,
                              completion: @escaping (MDResult<MDStatistic>?, MDApiError?) -> Void)
    {
        let url = MDPath.chapterStatistics(chapterId: chapterId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    func getChaptersStatistics(chapterIds: [String],
                               completion: @escaping (MDStatistic?, MDApiError?) -> Void)
    {
        let url = MDPath.chaptersStatistics(chapterIds: chapterIds)
        performBasicGetCompletion(url: url, completion: completion)
    }

    func getGroupStatistics(groupId: String,
                            completion: @escaping (MDStatistic?, MDApiError?) -> Void)
    {
        let url = MDPath.groupStatistics(groupId: groupId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    func getGroupsStatistics(groupIds: [String],
                             completion: @escaping (MDStatistic?, MDApiError?) -> Void)
    {
        let url = MDPath.groupsStatistics(groupIds: groupIds)
        performBasicGetCompletion(url: url, completion: completion)
    }

    func getMangaStatistics(mangaId: String,
                            completion: @escaping (MDStatistic?, MDApiError?) -> Void)
    {
        let url = MDPath.mangaStatistics(mangaId: mangaId)
        performBasicGetCompletion(url: url, completion: completion)
    }

    func getMangasStatistics(mangaIds: [String],
                             completion: @escaping (MDStatistic?, MDApiError?) -> Void)
    {
        let url = MDPath.mangasStatistics(mangaIds: mangaIds)
        performBasicGetCompletion(url: url, completion: completion)
    }
}

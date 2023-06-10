//
//  MDApi+Chapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 10/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

extension MDApi {
    
    /// Get the list of latest published chapters
    /// - Parameter filter: The filter to use
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func getChapterList(filter: MDChapterFilter? = nil,
                               includes: [MDObjectType]? = nil,
                               completion: @escaping (MDResultList<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.getChapterList(filter: filter, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }
    
    /// View the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter includes: The additional relationships to load (see Reference Expansion)
    /// - Parameter completion: The completion block called once the request is done
    public func viewChapter(chapterId: String,
                            includes: [MDObjectType]? = nil,
                            completion: @escaping (MDResult<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.viewChapter(chapterId: chapterId, includes: includes)
        performBasicGetCompletion(url: url, completion: completion)
    }
    
    /// Update the specified chapter's information
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter info: The chapter information
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func updateChapter(chapterId: String,
                              info: MDChapter,
                              completion: @escaping (MDResult<MDChapter>?, MDApiError?) -> Void) {
        let url = MDPath.updateChapter(chapterId: chapterId)
        performBasicPutCompletion(url: url, data: info, completion: completion)
    }
    
    /// Delete the specified chapter
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func deleteChapter(chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        let url = MDPath.deleteChapter(chapterId: chapterId)
        performDelete(url: url) { (response) in
            completion(response.error)
        }
    }
    
    /// Mark the specified chapter as read
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func markChapterRead(mangaId: String, chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        markChapters(mangaId: mangaId, readChapterIds: [chapterId], unreadChapterIds: []) { (response) in
            completion(response)
        }
    }
    
    /// Mark the specified chapter as unread
    /// - Parameter chapterId: The id of the chapter
    /// - Parameter completion: The completion block called once the request is done
    /// - Precondition: The user must be logged-in
    public func markChapterUnread(mangaId: String, chapterId: String, completion: @escaping (MDApiError?) -> Void) {
        markChapters(mangaId: mangaId, readChapterIds: [], unreadChapterIds: [chapterId]) { (response) in
            completion(response)
        }
    }
    
    
    public func markChapters(mangaId: String, readChapterIds: [String], unreadChapterIds: [String], completion: @escaping (MDApiError?) -> Void){
        let url = MDPath.markChapterRead(mangaId: mangaId)
        let chapters = MDMarkChapters(chapterIdsRead: readChapterIds, chapterIdsUnread: unreadChapterIds)
        performPost(url: url, body: chapters) { (response) in
            completion(response.error)
        }
    }
    
}

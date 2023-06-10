//
//  MDChapter.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a manga chapter returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDChapter {
    
    /// The chapter's title
    public let title: String?
    
    /// The volume this chapter belongs to, if entered by the uploader
    public let volume: String?
    
    /// The chapter in the printed manga which corresponds to this chapter
    /// - Note: This may be `nil` string if the uploader did not provide a chapter number (e.g. for oneshots)
    public let chapter: String?
    
    /// The language in which this chapter was translated
    public let language: Locale?
    
    /// The date at which this chapter entry was created on MangaDex
    public let createdDate: Date
    
    /// The date of the last update made to this chapter entry on MangaDex
    /// - Note: This property will be `nil` if the chapter was never modified after being created
    public let updatedDate: Date?
    
    /// The date at which this chapter will be or has been published
    /// - Note: This may differ from the `createdDate` property as scanlation groups might impose delays
    public let publishDate: Date?
    
    /// The version of this type of object in the MangaDex API
    public let version: Int
    
    /// The list of page URLs for this chapter using the specified node URL
    /// - Parameter node: The URL of the server to use to fetch these images
    /// - Parameter lowRes: Whether to get the low resolution version of the image or not
    public func getPageUrls(details : MDAtHomeNode, lowRes: Bool = false ) -> [URL] {
        var out: [URL] = []
        let pageIds = lowRes ? details.chapter.dataSaver : details.chapter.data
        for pageId in pageIds {
            out.append(MDPath.getChapterPage(baseURL: details.baseUrl, chapterHash: details.chapter.hash, pageId: pageId, lowRes: lowRes))
        }
        return out
    }
    
}

extension MDChapter: Decodable {
    
    /// Mapping between MangaDex's API JSON keys and the class' variable names
    enum CodingKeys: String, CodingKey {
        case title
        case volume
        case chapter
        case language = "translatedLanguage"
        case hash
        case pages = "data"
        case pagesLowRes = "dataSaver"
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case publishDate = "publishAt"
        case checksums
        case version
    }
    
    /// Custom `init` implementation to handle decoding the `language` attribute
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String?.self, forKey: .title)
        volume = try container.decode(String?.self, forKey: .volume)
        chapter = try container.decode(String?.self, forKey: .chapter)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        updatedDate = try container.decode(Date?.self, forKey: .updatedDate)
        publishDate = try container.decode(Date?.self, forKey: .publishDate)
        version = try container.decode(Int.self, forKey: .version)
        
        // Manually decode the language code to convert it from a String to a Locale
        if let langCode = try container.decode(String?.self, forKey: .language) {
            language = Locale.init(identifier: langCode)
        } else {
            language = nil
        }
    }
    
}

extension MDChapter: Encodable {
    
    /// Convenience `init` used for update endpoints
    public init(title: String?,
                volume: String? = nil,
                chapter: String? = nil,
                language: Locale,
                pages: [String],
                pagesLowRes: [String]) {
        self.title = title
        self.volume = volume
        self.chapter = chapter
        self.language = language
        createdDate = .init()
        updatedDate = nil
        publishDate = nil
        
        // Hardcoded based on the API version we support
        version = 1
    }
    
    /// Custom `encode` implementation to handle encoding the `language` attribute
    ///
    /// The MangaDex API does not expect the same thing when encoding an `MDChapter` as when decoding it, which makes
    /// this a bit awkward. See https://api.mangadex.org/docs.html#operation/put-chapter for more details
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(volume, forKey: .volume)
        try container.encode(chapter, forKey: .chapter)
        try container.encode(version, forKey: .version)
        
        // Manually encode the language code
        // The language cannot be nil when uploading a chapter
        try container.encode(language!.identifier, forKey: .language)
    }
    
}

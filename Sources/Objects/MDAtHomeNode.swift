//
//  MDAtHomeNode.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 10/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an MD@Home node
public struct MDAtHomeNode: Decodable {
    
    /// The status of the result returned by the MangaDex API
    public let result: MDResultStatus
    
    /// The base URL of this MD@Home node
    public let baseUrl: URL
    
    public let chapter: ChapterImages
    
}

public struct ChapterImages:Decodable {
    public let hash : String
    
    public let data: [String]
    
    public let dataSaver:[String]
}

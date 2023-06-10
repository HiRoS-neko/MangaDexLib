//
//  MDGroup.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 29/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a group returned by MangaDex
/// This is passed in the `data` property of an `MDObject`
public struct MDGroup {
    
    /// The group's name
    public let name: String
    
    public let altNames: [MDLocalizedString]
    
    public let locked : Bool?
    
    public let website : URL?
    
    public let ircServer : String?
    
    public let ircChannel : String?
    
    public let discord : String?
    
    public let contactEmail : String?
    
    public let description : String?
    
    public let twitter : URL?
    
    public let mangaUpdates : URL?
    
    public let focusedLanguages : [String]
    
    public let official : Bool?
    
    public let verified : Bool?
    
    public let inactive : Bool?
    
    public let publishDelay : String?
    
    /// The date at which this group was created on MangaDex
    public let createdDate: Date
    
    /// The date of the last update made to this group's information on MangaDex
    /// - Note: This property will be `nil` if the group was never modified after being created
    public let updatedDate: Date?
    
    /// The version of this type of object in the MangaDex API
    public let version: Int
    
}

extension MDGroup: Decodable {
    
    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case name
        case altNames
        case locked
        case website
        case ircServer
        case ircChannel
        case discord
        case contactEmail
        case description
        case twitter
        case mangaUpdates
        case focusedLanguages
        case official
        case verified
        case inactive
        case publishDelay
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case version
    }
    
}

extension MDGroup: Encodable {
    
    /// Convenience `init` used for create/update endpoints
    public init(name: String, leaderId: String, memberIds: [String]) {
        self.name = name
        
        self.altNames = []
        self.locked = nil
        self.website = nil
        self.ircServer = nil
        self.ircChannel = nil
        self.discord = nil
        self.contactEmail = nil
        self.description = nil
        self.twitter = nil
        self.mangaUpdates = nil
        self.focusedLanguages = []
        self.official = nil
        self.verified = nil
        self.inactive = nil
        self.publishDelay = nil
        
        createdDate = .init()
        updatedDate = nil
        
        // Hardcoded based on the API version we support
        version = 1
    }
    
    /// Custom `encode` implementation to convert this structure to a JSON object
    // TODO properly do the encode
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(version, forKey: .version)
    }
    
}

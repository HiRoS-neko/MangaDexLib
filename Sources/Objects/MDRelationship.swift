//
//  MDRelationship.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing an relationship info returned by the MangaDex API
public struct MDRelationship: Decodable {
    
    /// The ID of the object referenced by this relationship
    public let objectId: String
    
    /// The kind of object referenced by this relationship
    public let objectType: MDObjectType
    
    
    public let attributes: MDAttributes?
}

extension MDRelationship {
    
    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case objectType = "type"
        case attributes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try container.decode(String.self, forKey: .objectId)
        self.objectType = try container.decode(MDObjectType.self, forKey: .objectType)
        var temp : MDAttributes?
        do{
            switch objectType {
            case .manga:
                // The associated value is a Cover Art
                temp = try container.decode(MDManga.self, forKey: .attributes)
            case .chapter:
                // The associated value is an Int
                temp = try container.decode(MDChapter.self, forKey: .attributes)
            case .cover_art:
                // The associated value is a Cover Art
                temp = try container.decode(MDCover.self, forKey: .attributes)
            case .author:
                // The associated value is an Int
                temp = try container.decode(MDAuthor.self, forKey: .attributes)
            case .artist:
                // The associated value is a Cover Art
                temp = try container.decode(MDAuthor.self, forKey: .attributes)
            case .scanlationGroup:
                // The associated value is an Int
                temp = try container.decode(MDGroup.self, forKey: .attributes)
            case .tag:
                // The associated value is a Cover Art
                temp = try container.decode(MDTag.self, forKey: .attributes)
            case .user:
                // The associated value is an Int
                temp = try container.decode(MDUser.self, forKey: .attributes)
            case .creator:
                // The associated value is a Cover Art
                temp = try container.decode(MDAuthor.self, forKey: .attributes)
            case .member:
                // The associated value is an Int
                temp = try container.decode(MDUser.self, forKey: .attributes)
            case .leader:
                // The associated value is a Cover Art
                temp = try container.decode(MDUser.self, forKey: .attributes)
            case .customList:
                // The associated value is an Int
                temp = try container.decode(MDCustomList.self, forKey: .attributes)
            case .legacyMapping:
                // The associated value is a Cover Art
                temp = try container.decode(MDMapping.self, forKey: .attributes)
            default:
                temp = nil
            }
        }
        catch{
            temp = nil
        }
        self.attributes = temp
    }
}

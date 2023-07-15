//
//  MDResult.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 07/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import Foundation

/// Structure representing a result returned by the MangaDex API
public struct MDResult<T: Decodable>: Decodable {

    /// The status of the result returned by the MangaDex API
    public let result: MDResultStatus

    /// The decoded object contained in this response
    /// - Note: This will be `nil` if the status is not `ok`
    public let data: MDObject<T>?

    /// The token information returned during authentication
    /// - Note: This will be nil for requests outside of the `auth` endpoint
    public let token: MDToken?

    /// The optional message in this result
    public let message: String?

    /// The errors contained in this response
    /// - Note: This will be `nil` if the status is `ok`
    public let errors: [MDError]?
    
    /// The statistics contained in the response
    ///  - Note: This will be `nil` if the response was not from a statistics endpoint
    public let statistics: [String : T]?

}

extension MDResult {

    /// Coding keys to map JSON data to our struct
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case data = "data"
        case token
        case message
        case errors
        case statistics
    }

}

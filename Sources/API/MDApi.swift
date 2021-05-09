//
//  MDApi.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 28/04/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

/// The main MangaDex API class, which should be used to access the framework's capabilities
public class MDApi: NSObject {

    /// Base URL for the MangaDex API
    public static let baseURL = "https://api.mangadex.org"

    /// Default value appended after the default User-Agent for all requests made by the MangaDexLib
    public static let defaultUserAgent = "MangaDexLib"

    /// Instance of `MDRequestHandler` used to perform all requests
    public let requestHandler = MDRequestHandler()

    /// Session token provided by the API after login
    /// - Note: This token is valid for 15 minutes and must be refreshed afterwards
    public internal(set) var sessionJwt: String? {
        didSet {
            requestHandler.authToken = sessionJwt
        }
    }

    /// Refresh token provided by the API after login
    /// - Note: This token is valid for 4 hours and can be used to obtain a new `sessionJwt`
    public internal(set) var refreshJwt: String?

    /// TypeAlias for completion blocks
    public typealias MDCompletion = (MDResponse) -> Void

    /// Setter for the User-Agent to use for requests
    public func setUserAgent(_ userAgent: String) {
        requestHandler.setUserAgent(userAgent)
    }

}

// MARK: - MDApi Generic Helper Methods

extension MDApi {

    /// Wrapper around MDRequestHandler's get method
    /// - Parameter url: The URL to fetch
    /// - Parameter completion: The completion block called once the request is done
    func performGet(url: URL, completion: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, completion: completion)
        requestHandler.get(url: url, completion: completion)
    }

    /// Wrapper around MDRequestHandler's post method
    /// - Parameter url: The URL to load
    /// - Parameter body: The content of the request
    /// - Parameter completion: The completion block called once the request is done
    ///
    /// If `success` is called, then `response.error` is nil and `response.rawValue` is not nil
    func performPost<T: Encodable>(url: URL, body: T, completion: @escaping MDCompletion) {
        let completion = requestCompletionBlock(url: url, completion: completion)
        requestHandler.post(url: url, content: body, completion: completion)
    }

    /// Constructor for a generic completion block
    /// - Parameter url: The URL to load
    /// - Parameter completion: The completion block called once the request is done
    private func requestCompletionBlock(url: URL,
                                        completion: @escaping MDCompletion) -> MDRequestHandler.RequestCompletion {
        return { (httpResponse, content, error) in
            // Build a response object for the completion
            let response = MDResponse(url: url,
                                      content: content,
                                      error: error,
                                      status: httpResponse?.statusCode)

            // If there is an error with status code 403, it may be because of a captcha
            if let statusCode = httpResponse?.statusCode, statusCode == 403,
               let body = content, body.contains("captcha_required_exception") {
                response.error = MDApiError(type: .captchaRequired, body: content, error: error?.underlyingError)
            }

            // If not, we still want to make sure the status code is correct
            if let statusCode = httpResponse?.statusCode, !(200..<400).contains(statusCode) {
                response.error = MDApiError(type: .wrongStatusCode, body: content, error: error?.underlyingError)
            }

            completion(response)
        }
    }

}

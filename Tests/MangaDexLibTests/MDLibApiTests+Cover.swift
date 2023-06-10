//
//  MDLibApiTests+Cover.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 05/06/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetCoverList() throws {
        let expectation = self.expectation(description: "Get a list of covers")
        api.getCoverList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchCovers() throws {
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let filter = MDCoverFilter(mangas: [mangaId])
        filter.limit = 2
        filter.offset = 1

        let expectation = self.expectation(description: "Get a list of covers")
        api.getCoverList(filter: filter) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            XCTAssertEqual(result?.limit, filter.limit)
            XCTAssertEqual(result?.offset, filter.offset)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewCover() throws {
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let coverId = "e6583e52-1125-4c50-8db4-e8d6cf3fb144" // Solo leveling volume 1
        let expectation = self.expectation(description: "Get the cover's information")
        api.viewCover(coverId: coverId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data?.attributes)
            XCTAssertEqual(result?.data?.attributes.volume, "4")

            let coverMangaId = result?.data?.relationships.first(where: { (relationship) -> Bool in
                return relationship.objectType == .manga
            })
            XCTAssertEqual(coverMangaId?.objectId, mangaId)

            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetCoverImage() throws {
        let coverId = "e6583e52-1125-4c50-8db4-e8d6cf3fb144" // Solo leveling volume 1

        // Start by getting information about the cover
        var cover: MDCover?
        var mangaId: String?
        let coverExpectation = self.expectation(description: "Get the cover's information")
        api.viewCover(coverId: coverId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data?.attributes)
            XCTAssertEqual(result?.data?.attributes.volume, "4")

            let mangaRelationship = result?.data?.relationships.first(where: { (relationship) -> Bool in
                return relationship.objectType == .manga
            })
            XCTAssertNotNil(mangaRelationship)

            cover = result?.data?.attributes
            mangaId = mangaRelationship?.objectId
            coverExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // Now, build the cover's URL
        let coverURL = cover?.getCoverUrl(mangaId: mangaId!)
        XCTAssertNotNil(coverURL)

        // And download the cover from the URL
        let imageExpectation = self.expectation(description: "Download the cover image")
        URLSession.shared.dataTask(with: coverURL!) { (data, response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            imageExpectation.fulfill()
        }.resume()
        waitForExpectations(timeout: 15, handler: nil)
    }

}

//
//  MDLibApiTests+Manga.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetMangaList() throws {
        let mangaExpectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchMangas() throws {
        let filter = MDMangaFilter(title: "Solo")
        filter.createdAtSince = .init(timeIntervalSince1970: 0)
        filter.limit = 8
        filter.offset = 22

        let expectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList(filter: filter) { (result, error) in
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

    func testMangaListReferenceExpansion() throws {
        let includes: [MDObjectType] = [
            .author, .artist, .cover_art
        ]
        let mangaExpectation = self.expectation(description: "Get a list of mangas")
        api.getMangaList(includes: includes) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            for manga in result!.data {
                XCTAssertNotNil(manga.relationships)
                XCTAssertNotNil(manga.attributes)
                let relationshipTypes = manga.relationships.map { $0.objectType }
                for objType in includes {
                    XCTAssert(relationshipTypes.contains(objType))
                }
            }
            mangaExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaTagList() throws {
        let expectation = self.expectation(description: "Get a list of manga tags")
        api.getMangaTagList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetRandomManga() throws {
        let expectation = self.expectation(description: "Get a random manga")
        api.getRandomManga { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data)
            XCTAssertNotNil(result?.data?.attributes)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testViewManga() throws {
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's information")
        api.viewManga(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data?.attributes)
            XCTAssertEqual(result?.data?.attributes.title.translations.first?.value, "Official \"Test\" Manga")
            XCTAssertEqual(result?.data?.attributes.altTitles.first?.translations.first?.value, "TEST edited")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testGetCoverArt() throws {
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's cover art uri")
        var mangaCoverArt : MDCover?
        api.viewManga(mangaId: mangaId, includes: [.cover_art]) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data?.attributes)
            mangaCoverArt = result?.data!.relationships.first(where: { (relationship) -> Bool in
                return relationship.objectType == .cover_art
            })?.attributes as? MDCover
            let uri =  mangaCoverArt?.getCoverUrl(mangaId: mangaId)
            XCTAssertNotNil(uri)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testFollowUnfollowManga() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga

        // Assume the manga isn't part of the follow list and start following it
        let followExpectation = self.expectation(description: "Follow the manga")
        api.followManga(mangaId: mangaId) { (error) in
            XCTAssertNil(error)
            followExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's followed mangas and check it was added
        let listFollowExpectation1 = self.expectation(description: "List the user's followed mangas")
        api.getLoggedUserFollowedMangaList(pagination: MDPaginationFilter(limit: 100)) { (result, error) in
            XCTAssertNil(error)

            var followedMangaIds: [String] = []
            for manga in result?.data ?? [] {
                followedMangaIds.append(manga.objectId)
            }
            XCTAssertTrue(followedMangaIds.contains(mangaId))
            listFollowExpectation1.fulfill()
        }

        // Unfollow the manga to cleanup
        let unfollowExpectation = self.expectation(description: "Unfollow the manga")
        api.unfollowManga(mangaId: mangaId) { (error) in
            XCTAssertNil(error)
            unfollowExpectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)

        // List the user's follow mangas and check it was removed
        let listFollowExpectation2 = self.expectation(description: "List the user's followed mangas")
        api.getLoggedUserFollowedMangaList { (result, error) in
            XCTAssertNil(error)

            var followedMangaIds: [String] = []
            for manga in result?.data ?? [] {
                followedMangaIds.append(manga.objectId)
            }
            XCTAssertFalse(followedMangaIds.contains(mangaId))
            listFollowExpectation2.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaFeed() throws {
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's chapters")
        //var filter = MDFeedFilter(locales: [Locale.init(identifier: "vi"), Locale.init(identifier: "en"),])
        api.getMangaFeed(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaVolumesAndChapters() throws {
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's aggregated data")
        api.getMangaVolumesAndChapters(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.volumes.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaReadMarkers() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's list of read chapters")
        api.getMangaReadMarkers(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.chapters)
            XCTAssert(result!.chapters!.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangasReadMarkers() throws {
        // Assume the test account has marked some chapters from one of these mangas as read
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaIds = [
            "f9c33607-9180-4ba6-b85c-e4b5faee7192", // Official "Test" Manga
            "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        ]
        let expectation = self.expectation(description: "Get the mangas' list of read chapters")
        api.getMangasReadMarkers(mangaIds: mangaIds) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.chapters)
            XCTAssert(result!.chapters!.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetReadingStatuses() throws {
        try login(api: api, credentialsKey: "AuthRegular")
        let expectation = self.expectation(description: "Get the list of manga statuses")
        api.getReadingStatuses { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.statuses)
            XCTAssert(result!.statuses!.count > 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaReadingStatus() throws {
        // Assume the test account has set a reading status for this manga
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "32d76d19-8a05-4db0-9fc2-e0b0648fe9d0" // Solo leveling
        let expectation = self.expectation(description: "Get the manga's reading status")
        api.getMangaReadingStatus(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testGetMangaNoReadingStatus() throws {
        // Assume the test account has NOT set a reading status for this manga
        try login(api: api, credentialsKey: "AuthRegular")
        let mangaId = "f9c33607-9180-4ba6-b85c-e4b5faee7192" // Official "Test" Manga
        let expectation = self.expectation(description: "Get the manga's reading status")
        api.getMangaReadingStatus(mangaId: mangaId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}

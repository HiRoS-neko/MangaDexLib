//
//  MDLibApiTests+Author.swift
//  MangaDexLibTests
//
//  Created by Jean-Romain on 13/05/2021.
//  Copyright © 2021 JustKodding. All rights reserved.
//

import XCTest
import MangaDexLib

extension MDLibApiTests {

    func testGetAuthorList() throws {
        let expectation = self.expectation(description: "Get a list of authors")
        api.getAuthorList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssert(result!.data.count > 0)
            XCTAssertNotNil(result?.data.first?.attributes)
            XCTAssertNotNil(result?.data.first?.attributes)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSearchAuthors() throws {
        let filter = MDAuthorFilter(name: "ONE")
        filter.limit = 4
        filter.offset = 0

        let expectation = self.expectation(description: "Get a list of authors")
        api.getAuthorList(filter: filter) { (result, error) in
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

    func testViewAuthor() throws {
        let authorId = "16b98239-6452-4859-b6df-fdb1c7f12b52" // One
        let expectation = self.expectation(description: "Get the author's information")
        api.viewAuthor(authorId: authorId) { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            XCTAssertNotNil(result?.data?.attributes)
            XCTAssertEqual(result?.data?.attributes.name, "One")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
    }

}

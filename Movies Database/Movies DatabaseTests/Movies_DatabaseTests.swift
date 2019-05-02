//
//  Movies_DatabaseTests.swift
//  Movies DatabaseTests
//
//  Created by Umair Ali on 27/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import XCTest
@testable import Movies_Database

class Movies_DatabaseTests: XCTestCase {
    var movieDataSource : MovieDataSource?
    
    override func setUp() {
        movieDataSource = MovieDataSource()
    }

    override func tearDown() {
        movieDataSource = nil
    }

    func testCreateReques() {
        XCTAssert(movieDataSource?.createRequest().urltoHit.contains("page") ?? false)
    }
    
    func testSendAPICall(){
        
        let expectation  = XCTestExpectation.init(description: "Movie fetch api hit expectation")
        movieDataSource?.sendApiCall(appRequest: (movieDataSource?.createRequest())!, success: { movies, pages in
            expectation.fulfill()
            XCTAssertTrue(movies.count>0)
        }, failure: { error in
            XCTFail(error.description)
        })
        
        wait(for: [expectation], timeout: 5)
    }
}

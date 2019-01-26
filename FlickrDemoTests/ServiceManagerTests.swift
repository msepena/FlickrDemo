//
//  ServiceManagerTests.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/25/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
import Foundation
@testable import FlickrDemo

class ServiceManagerTests: XCTestCase {
    
    var services: ServiceManager!

    override func setUp() {
        services = ServiceManager.shared
    }

    override func tearDown() {
        
    }

    func testSearchByQueryShouldReturnTheExactCount() {
        let expectation = self.expectation(description: "searh_query")
        self.services.searchBy("kittens", page: 10) { (result) in
            if let response = result, let photos = response.photos {
                XCTAssertEqual(photos.count, 20)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchImageShouldExecuteCompletionBlock() {
        let expectation = self.expectation(description: "fetch_image")
        self.services.fetchImageFor(TestUtils.shared.fetchPhotos()!.photos!.first!, IndexPath(row: 0, section: 0)) { (result) in
            XCTAssertNotNil(result, "should be executed block")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}



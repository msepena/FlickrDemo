//
//  EndPointTests.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/24/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
@testable import FlickrDemo

class EndPointTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchFunctionReturnURL() {
        let url = FlickrEndpoint.search(query:"kittens", page: 1).url!.absoluteString
        let expectedUrl = "https://api.flickr.com/services/rest?api_key=de24642a8668fb0318ec5b9cecfda18c&method=flickr.photos.search&text=kittens&per_page=20&format=json&nojsoncallback=1&page=1";
        XCTAssert(url == expectedUrl, "Url's should be same")
        
    }
    
    func testSearchFunctionReturnDifferentURL() {
        let url = FlickrEndpoint.search(query:"kitt", page: 1).url!.absoluteString
        let expectedUrl = "https://api.flickr.com/services/rest?api_key=de24642a8668fb0318ec5b9cecfda18c&method=flickr.photos.search&text=kittens&per_page=20&format=json&nojsoncallback=1&page=1";
        XCTAssert(url != expectedUrl, "Url's should be not be the same")
        
    }

}

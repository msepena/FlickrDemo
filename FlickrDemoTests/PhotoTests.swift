//
//  PhotoTests.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/24/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
@testable import FlickrDemo

class PhotoTests: XCTestCase {
    var photo: Photo!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let resp = TestUtils.shared.fetchPhotos(),  let photos = resp.photos{
            self.photo = photos.first!
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPhotoObjectShouldReturnValidUrl() {
        let url = self.photo.url
        XCTAssertNotNil(url, "url should have valid value")
    }
    
    func testPhotoUrlShouldBeEqual() {
        let url = self.photo.url!.absoluteString
        XCTAssertEqual(url, "https://farm2.staticflickr.com/1935/44852926745_7cfe0aa684.jpg",  "url should be equal")
        
    }


}

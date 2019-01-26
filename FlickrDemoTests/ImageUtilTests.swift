//
//  ImageUtilMock.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/25/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
import Foundation
@testable import FlickrDemo

class ImageUtilTests: XCTestCase {
    
    
    var opsQueue = MockOperationManager()
    var imageUtil: ImageCache!
    
    override func setUp() {
        imageUtil = ImageUtil()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetImage() {
        // This is an example of a functional test case.
        let expectation = self.expectation(description: "DownloaImage")
        let photoUrl = TestUtils.shared.url(of: "test.jpg")
        let index = IndexPath(row: 0, section: 0)
        imageUtil.downloadImage(at: photoUrl, indexPath: index) { (result) in
            if case ImageResult.error( _,  let indexPath) = result {
                XCTAssertEqual(indexPath, index, "should return the same indexpaths")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4, handler: nil)
    }
    
    func testGetImageReturnsFailure() {
        // This is an example of a functional test case.
        let expectation = self.expectation(description: "DownloaImage")
        let photoUrl = URL(string: "https://4918/45946787685_d26ffb7a5b.jpg")!
        imageUtil.downloadImage(at: photoUrl, indexPath: IndexPath(row: 0, section: 0)) { (result) in
            if case ImageResult.error(let error,  _) = result {
                XCTAssertNotNil(error, "should return the  error")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

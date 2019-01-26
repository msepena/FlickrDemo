//
//  SearchViewModelTests.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/24/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
@testable import FlickrDemo

class SearchViewModelTests: XCTestCase {


    let opsQueue = MockOperationManager()
    let services = MockServices()
    var searchViewModel: SearchViewModal!
    let mockView = MockSearchView()
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        searchViewModel = SearchViewModal(opsQueue, services)
        searchViewModel.searchView = mockView
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSarchQueryInvalidCondition() {
        searchViewModel.count = 10
        searchViewModel.query = ""
        XCTAssert(searchViewModel.count != 0, "Count should n't be updated")
        
    }
    
    func testSarchValidQueryShouldLoadPages() {
        let expectation = self.expectation(description: "search_query")
        searchViewModel.count = 0
        searchViewModel.query = "Kitte"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockView.state, State.completed, "state should be in completed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPrefetchIndexesShouldLoadPages() {
        let expectation = self.expectation(description: "preferch_page")
        searchViewModel.prefetchData(for: [IndexPath(row: 0, section: 0)], searchTerm: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.searchViewModel.count, 22027, "should load the page")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPrefetchIndexesShouldLoadPagesBeforeImages() {
        let expectation = self.expectation(description: "preferch_indexpaths")
        searchViewModel.fetchData(at: IndexPath(row: 0, section: 0))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.searchViewModel.count, 22027, "should load the page before images")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPrefetchIndexesShouldLoadImagesAtIndexpaths() {
        let expectation = self.expectation(description: "preferch_indexpaths")
        searchViewModel.photoLookup[IndexPath(row: 0, section: 0)] = TestUtils.shared.fetchPhotos()!.photos!.first
        searchViewModel.fetchData(at: IndexPath(row: 0, section: 0))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.mockView.cellForItemCalled, true, "should load the image at index path")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}

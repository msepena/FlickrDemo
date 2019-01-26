//
//  TaskQueueTests.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/25/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import XCTest
import Foundation
@testable import FlickrDemo

class TaskQueueTests: XCTestCase {
    
    class MockOperation: AsyncTask {
        var timeAfter:Double!
        convenience init(_ identifier: String, time: Double) {
            self.init(identifier)
            self.timeAfter = time
        }
        override func execute() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeAfter) {
                self.finish(true)
            }
        }
    }
    
    var opManager: TaskQueue!

    override func setUp() {
        opManager = FlickrTaskQueue.shared
    }

    override func tearDown() {
        
    }

    func testAddOperationShouldReturnValue() {
        let identifier = "mock_operation"
        let expectation = self.expectation(description: identifier)
        let mockOp = MockOperation(identifier, time: 0.0)
        mockOp.completionBlock = {
            XCTAssertEqual(identifier, mockOp.identifier, "should be same identifier ")
            expectation.fulfill()
        }
        self.opManager.add(mockOp)
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testCancelAll()  {
        self.opManager.add(MockOperation("2", time: Double(2)))
        self.opManager.cancelAll()
        let expectation = self.expectation(description: "cancel_all")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            XCTAssertNil(self.opManager.task(for: "\(2)"), "should cancel all the operations")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
    func testCancelOperationByIdentifier()  {
        self.opManager.add(MockOperation("4", time: Double(2)))
        self.opManager.cancel(identifier: "4")
        XCTAssertNil(self.opManager.task(for: "4"), "should cancel the operation")
    }
    
    func testFindOperationShouldReturnValue() {
        let identifier = "mock_operation"
        let expectation = self.expectation(description: identifier)
        let mockOp = MockOperation(identifier, time: 0.5)
        self.opManager.add(mockOp)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            if let id1 =  self.opManager.task(for: identifier)?.identifier, id1 == identifier {
                XCTAssertEqual(identifier, mockOp.identifier, "should return same identifier ")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        
    }
    
   

}

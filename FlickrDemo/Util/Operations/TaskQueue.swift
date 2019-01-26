//
//  TaskQueue.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation

protocol TaskQueue {
    
    func add(_ task: AsyncTask) -> Void
    
    func cancel(identifier: String) -> Void
    
    func cancelAll() -> Void
    
    func execute(_ block: @escaping () -> Void) -> Void
    
    func task(for identifier: String) -> AsyncTask?
    
}

struct FlickrTaskQueue: TaskQueue {
    
    /// A serial `OperationQueue` to lock access to the `fetchQueue`
    private let serialAccessQueue = OperationQueue()
    
    /// An `OperationQueue` that contains `AsyncTask`s for requested data.
    private let fetchQueue = OperationQueue()
    
    private init() {
        serialAccessQueue.maxConcurrentOperationCount = 1
    }
    
    static let shared = FlickrTaskQueue()
    
    // Add operation to fetchQueue
    func add(_ task: AsyncTask) -> Void {
        serialAccessQueue.addOperation {
            if self.task(for: task.identifier) == nil{
                self.fetchQueue.addOperation(task)
            }
        }
    }
    
    func cancel(identifier: String) -> Void {
        serialAccessQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }
            guard let op = self.task(for: identifier) else {
                return
            }
            op.cancel()
        }
    }
    
    func cancelAll() -> Void {
        serialAccessQueue.addOperation {
            self.fetchQueue.isSuspended = true
            defer {
                self.fetchQueue.isSuspended = false
            }
            self.fetchQueue.cancelAllOperations()
        }
    }
    
    // execute serailly
    func execute(_ block: @escaping () -> Void) -> Void {
        serialAccessQueue.addOperation {
            block()
        }
    }
    
    func task(for identifier: String) -> AsyncTask? {
        for case let fetchTask as AsyncTask in fetchQueue.operations
            where !fetchTask.isCancelled && fetchTask.identifier == identifier {
                return fetchTask
        }
        return nil
    }
}

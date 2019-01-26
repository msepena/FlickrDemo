//
//  AsyncTask.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation

class AsyncTask: Operation {
    
    let identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    override func start() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        self.execute()
    }
    
    // Overide this method in subclasses
    func execute() -> Void {
        fatalError()
    }

}

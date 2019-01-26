//
//  Mocks.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/25/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit
@testable import FlickrDemo


class MockOperationManager: TaskQueue {
    var ops: [AsyncTask] = []
    
    func add(_ operation: AsyncTask) -> Void {
        ops.append(operation)
        operation.completionBlock?()
    }
    
    func cancel(identifier: String) -> Void {
        ops = ops.filter({$0.identifier == identifier})
    }
    
    func cancelAll() -> Void {
        ops.removeAll()
    }
    
    func execute(_ block: @escaping () -> Void) -> Void {
        block()
    }
    
    func task(for identifier: String) -> AsyncTask? {
        return ops.filter({ $0.identifier == identifier}).first
    }
}

struct MockServices: Services {
    func searchBy(_ query: String, page: Int, completion:  @escaping ((PhotoResponse?) -> Void)) -> Void {
        let photosResp = TestUtils.shared.fetchPhotos()
        completion(photosResp)
    }
    
    func fetchImageFor(_ photo: Photo, _ indexPath: IndexPath, completion: @escaping ImageCompletionHandler) -> Void {
        let result = ImageResult.success(image: TestUtils.shared.image!, imageUrl: photo.url!, indexPath: indexPath)
        completion(result)
    }
}

class MockSearchView: SearchView {
    var reloadFlag: Bool = false
    var reloadIndexPaths: [IndexPath] = []
    var state: State = State.intial
    var cellForItemCalled: Bool = false
    
    // fetch the cell at index
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        cellForItemCalled = true
        return MockFlickrCell()
    }
    
    // get all visible indexes
    var indexPathsForVisibleItems: [IndexPath] {
        return [IndexPath(row: 0, section: 0)]
    }
    
    // reload the collectionview
    func reloadData() {
        self.reloadFlag = true
    }
    
    // reload only required scells
    func reloadItems(at indexPaths: [IndexPath]) {
        self.reloadIndexPaths = indexPaths
    }
    
    // show/hide progress
    func update(state: State) {
        self.state = state
    }
    
}

class MockFlickrCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FlickrEndpoint {
    func buildURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        switch self {
        case .search(_ , _):
            return TestUtils.shared.url(of: "photo.json")
        case .image(_):
            return TestUtils.shared.url(of: "test.jgp")
        }
    }
}

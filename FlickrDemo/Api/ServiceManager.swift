//
//  ServiceManager.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation

protocol Services {
    
    func searchBy(_ query: String, page: Int, completion:  @escaping ((PhotoResponse?) -> Void)) -> Void
    
    func fetchImageFor(_ photo: Photo, _ indexPath: IndexPath, completion: @escaping ImageCompletionHandler) -> Void
}

class ServiceManager: Services {
    
    private var queue: TaskQueue!
    static let shared = ServiceManager()
    init(_ taskQueue: TaskQueue = FlickrTaskQueue.shared) {
        self.queue = taskQueue
    }
    
    func searchBy(_ query: String, page: Int, completion: @escaping ((PhotoResponse?) -> Void)) -> Void {
        guard let url = FlickrEndpoint.search(query: query, page: page).url else { return }
        let pageTask = DataTask<PhotoResponse>(page, url: url)
        pageTask.completionBlock = { [weak pageTask] in
            completion(pageTask?.result)
        }
        pageTask.queuePriority = .high
        self.queue.add(pageTask)
    }
    
    func fetchImageFor(_ photo: Photo, _ indexPath: IndexPath, completion: @escaping ImageCompletionHandler) -> Void {
        guard let url = FlickrEndpoint.image(photo: photo).url else { return }
        ImageUtil.shared.downloadImage(at: url, indexPath: indexPath, completion: completion)
    }
}



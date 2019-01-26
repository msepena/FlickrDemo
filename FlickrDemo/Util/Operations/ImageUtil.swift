//
//  ImageUtil.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCompletionHandler = (ImageResult) -> Void


protocol ImageCache {
    func downloadImage(at url: URL, indexPath: IndexPath, completion: @escaping ImageCompletionHandler)
}

class ImageUtil: ImageCache {
    
    private var taskQueue:TaskQueue!
    static let shared = ImageUtil()
    private lazy var imageCache = NSCache<NSString, UIImage>()
    
    init(queue: TaskQueue = FlickrTaskQueue.shared) {
        self.taskQueue = queue
    }
    
    func downloadImage(at url: URL, indexPath: IndexPath, completion: @escaping ImageCompletionHandler) {
        self.taskQueue.execute {
            if let cachedImage = self.imageCache.object(forKey: url.absoluteString as NSString) {
                //print("Return cached Image for \(url)")
                completion(ImageResult.success(image: cachedImage, imageUrl: url, indexPath: indexPath))
            } else {
                // download the image from server
                var imageTask = self.taskQueue.task(for: url.absoluteString) as? ImageTask
                if imageTask == nil {
                    //print("Download Image task at \(url)")
                    imageTask = ImageTask(url: url, indexPath: indexPath)
                    imageTask?.completionBlock = {
                        guard let result = imageTask?.result else { return }
                        switch result {
                        case ImageResult.success(let image, let url, _):
                            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        case ImageResult.error(let error, _):
                            print("\(String(describing: error))")
                        }
                        completion(result)
                    }
                    imageTask?.queuePriority = .high
                    self.taskQueue.add(imageTask!)
                } else {
                    //print("Change Priority Image task at \(url)")
                    imageTask?.queuePriority = .veryHigh
                }
            }
        }
    }
}

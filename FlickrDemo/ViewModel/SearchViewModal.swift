//
//  SearchViewModal.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit

let minimu_query_length = 3
class SearchViewModal {
    private var opsQueue: TaskQueue!
    private var services: Services!
    
    convenience init() {
        self.init(FlickrTaskQueue.shared, ServiceManager.shared)
    }
    
    init(_ opsQueue: TaskQueue, _ services: Services) {
        self.opsQueue = opsQueue
        self.services = services
    }
    
    // views
    var searchView: SearchView?
    
    // buffer to holds pages downloaded pages
    private (set) var pages: [Int] = []
    
    // data models
    var count: Int = 0
    var photoLookup: [IndexPath: Photo] = [:]
    var query: String = "" {
        willSet {
            // compare the old value with new value and call ws
            if newValue.count >= minimu_query_length && newValue != query {
                self.opsQueue.execute { [weak self] in
                    self?.reset()
                    self?.updateUI()
                    self?.prefetchData(for: [IndexPath(row: 0, section: 0)], searchTerm: newValue)
                }
            }
        }
    }
    
    // reset all data
    private func reset() -> Void {
        self.opsQueue.cancelAll()
        self.pages.removeAll()
        self.count = 0
        self.photoLookup.removeAll()
    }
    
    // start the progress
    private func updateUI() {
        DispatchQueue.main.async {
            self.searchView?.update(state: .progress)
            self.searchView?.reloadData()
        }
    }
}

extension SearchViewModal {
    
    // Called from collection view prefetchItemsAt method
    func prefetchData(for indexPaths: [IndexPath], searchTerm: String?) -> Void {
        self.opsQueue.execute { [weak self] in
            let searchQuery = searchTerm ?? self!.query
            // Call pages
            indexPaths.pages
                .filter({!(self?.pages ?? []).contains($0)}  )
                .filter({self?.opsQueue.task(for: "\($0)") == nil})
                .forEach({ (page) in
                    self?.services.searchBy(searchQuery, page: page, completion: { (result) in
                        self?.updateUIForPage(page, result: result)
                    })
                })
        }
    }
    
    // Called from collectionview cancelPrefetchingForItemsAt method
    func cancelDownloadData(at indexPaths: [IndexPath]) -> Void {
        let _ = indexPaths.map({ return self.photoLookup[$0]})
            .filter({$0 != nil})
            .forEach( {return self.opsQueue.task(for: $0?.url?.absoluteString ?? "")?.cancel()})
    }
    
    private func updateUIForPage(_ page: Int, result: PhotoResponse? ) {
        guard let response = result else { return }
        self.updatePhotoMap(photos: response.photos!, page: page)
        DispatchQueue.main.async {
            // Update collection view visible cells
            self.pages.append(page)
            if self.count == 0 {
                self.searchView?.update(state: .completed)
                self.count = Int(response.total ?? "0")!
                self.searchView?.reloadData()
            } else {
                guard let visiblePaths = self.searchView?.indexPathsForVisibleItems else { return }
                self.searchView?.reloadItems(at: visiblePaths)
            }
        }
    }
    
    private func updatePhotoMap(photos: [Photo], page: Int) -> Void {
        self.opsQueue.execute {
            var index = 0
            let start = (page-1) * Limit
            photos.forEach({ (photo) in
                self.photoLookup[IndexPath(row: start + index, section: 0)] = photo
                index += 1
            })
        }
    }
}


extension SearchViewModal {
    
    // Load individual cells
    func fetchData(at indexPath: IndexPath) -> Void {
        self.opsQueue.execute {
            guard let photo = self.photoLookup[indexPath] else {
                // photo object was not present, call the page it internally calls the cell load
                self.prefetchData(for: [indexPath], searchTerm: nil)
                return
            }
            self.updateCollectionCell(at: indexPath, photo: photo)
        }
    }
    
    private func updateCollectionCell(at indexPath: IndexPath, photo: Photo) {
        self.services.fetchImageFor(photo, indexPath) { (result) in
            DispatchQueue.main.async {
                guard let cell = self.searchView?.cellForItem(at: indexPath) as? FlickrCell else {
                    return
                }
                if case let ImageResult.success(image,  _, index) = result, index == indexPath {
                    cell.imageView.image = image
                }
                else if case let ImageResult.error(_ , index) = result, index == indexPath {
                    cell.imageView.image = UIImage(named: "invalid_photo")
                }
            }
        }
    }
}


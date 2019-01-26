//
//  SearchDataSource.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import UIKit


class SearchDataSource: NSObject {
    private var viewModal: SearchViewModal
    
    init(_ viewModal: SearchViewModal) {
        self.viewModal = viewModal
    }
    
}

// MARK: UICollectionViewDataSource
extension SearchDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrCell.identifier, for: indexPath) as? FlickrCell else {
            fatalError()
        }
        cell.imageView.image = UIImage(named: "placeholder")
        return cell
    }
    
}

// MARK: UICollectionViewDataSourcePrefetching
extension SearchDataSource: UICollectionViewDataSourcePrefetching {
    
    /// - Tag: Prefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        //print("prefetchItemsAt \(indexPaths)")
        self.viewModal.prefetchData(for: indexPaths, searchTerm: nil)
    }
    
    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        //print("cancelPrefetchingForItemsAt \(indexPaths)")
        self.viewModal.cancelDownloadData(at: indexPaths)
    }
}

extension SearchDataSource: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModal.fetchData(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModal.cancelDownloadData(at: [indexPath])
    }    
    
}

//
//  SearchView.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit

enum State: Int {
    case intial = 0
    case progress
    case completed
}

protocol SearchView {
 
    // fetch the cell at index
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell?
    
    // get all visible indexes
    var indexPathsForVisibleItems: [IndexPath] { get }
    
    // reload the collectionview
    func reloadData()
    
    // reload only required scells
    func reloadItems(at indexPaths: [IndexPath])
    
    // show/hide progress
    func update(state: State)
    
}

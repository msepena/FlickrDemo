//
//  UICollectionCell+Identifier.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    /** View Identifier
     */
    static var identifier: String {
        return String(describing: self)
    }
}


extension IndexPath {
    var page: Int {
        return (self.row / Limit) + 1
    }
}

extension Array where Element == IndexPath {
    var pages: [Int] {
        var pagesToFetch: [Int] = []
        for indexPath in self {
            if !pagesToFetch.contains(indexPath.page){
                pagesToFetch.append(indexPath.page)
            }
        }
        return pagesToFetch
    }
}

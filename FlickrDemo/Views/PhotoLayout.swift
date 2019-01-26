//
//  PhotoLayout.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import UIKit

class PhotoLayout: UICollectionViewFlowLayout {
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let itemsPerRow: CGFloat = 3
    
    override func prepare() {
        super.prepare()
        guard let cv = collectionView else { return  }
        self.sectionInset = sectionInsets
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1) + self.minimumLineSpacing
        let availableWidth = cv.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        self.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
     
    }    
}

//
//  Photo.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation


struct Photo: Codable {
    let photoID: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case photoID = "id"
        case owner
        case secret
        case server
        case farm
        case title
    }
}

extension Photo {
    var url: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret).jpg")
    }
}

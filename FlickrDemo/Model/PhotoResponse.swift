//
//  PhotoResponse.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation

struct PhotoResponse {
    let status: String
    let page: Int?
    let totalPages: Int?
    let limit: Int?
    let total: String?
    let photos: [Photo]?
    
    enum CodingKeys: String, CodingKey {
        case status = "stat"
        case photos
    }
    
    enum PhotosKeys: String, CodingKey {
        case page
        case totalPages = "pages"
        case limit = "perpage"
        case total
        case photo
    }
}

extension PhotoResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        let photosInfo = try values.nestedContainer(keyedBy: PhotosKeys.self, forKey: .photos)
        page = try photosInfo.decode(Int.self, forKey: .page)
        totalPages = try photosInfo.decode(Int.self, forKey: .totalPages)
        limit = try photosInfo.decode(Int.self, forKey: .limit)
        total = try photosInfo.decode(String.self, forKey: .total)
        photos = try photosInfo.decode([Photo].self, forKey: .photo)
    }
}

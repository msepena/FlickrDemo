//
//  EndPoint.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation

let API_KEY = "3e7cc266ae2b0e0d78e279ce8e361736"
let Limit = 20

enum HTTPCode: Int {
    case success = 200
}

protocol Endpoint {
    var url: URL? {get}
}

extension Endpoint {
    
    func buildURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.host = "api.flickr.com"
        components.scheme = "https"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}

enum FlickrEndpoint: Endpoint {
    case search(query: String, page: Int)
    case image(photo: Photo)
    
    var url: URL? {
        switch self {
        case .search(let query, let page):
            return buildURL(path: "/services/rest", queryItems: [URLQueryItem(name: "api_key", value: API_KEY),
                                                       URLQueryItem(name: "method", value: "flickr.photos.search"),
                                                       URLQueryItem(name: "text", value: query),
                                                       URLQueryItem(name: "per_page", value: "\(Limit)"),
                                                       URLQueryItem(name: "format", value: "json"),
                                                       URLQueryItem(name: "nojsoncallback", value: "1"),
                                                       URLQueryItem(name: "page", value: "\(page)")])
            
        case .image(let photo):
            return photo.url
        }
    }
}



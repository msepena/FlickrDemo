//
//  TestUtil.swift
//  FlickrDemoTests
//
//  Created by muralis on 1/25/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import Foundation
import UIKit
@testable import FlickrDemo

class TestUtils {
    private var bundle: Bundle!
    static let shared: TestUtils = TestUtils()
    
    private init() {
        bundle = Bundle(for: type(of: self))
    }
    
    func fetchPhotos() -> PhotoResponse?{
        if let path = bundle.url(forResource: "photo", withExtension: "json"), let data = try? Data(contentsOf: path), let photoResponse = try? JSONDecoder().decode(PhotoResponse.self, from: data) {
            return photoResponse
        }
        return nil
    }
    
    var image:UIImage? {
        return UIImage(named: "placeholder")
    }
    
    func url(of resource:String) -> URL {
        return bundle.url(forResource: resource, withExtension: nil)!
    }
}

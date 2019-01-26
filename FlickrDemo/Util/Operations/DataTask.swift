//
//  DataTask.swift
//  FlickrDemo
//
//  Created by muralis on 1/23/19.
//  Copyright © 2019 muralis. All rights reserved.
//

import UIKit

final class DataTask<T: Decodable>: AsyncTask {
    
    private (set) var url: URL!
    var result: T?
    required init(_ page: Int, url: URL) {
        self.url = url
        super.init("\(page)")
    }
    
    override func execute() {
    
        let dataTask = URLSession.shared.dataTask(with: url) {(data, response, error) in
            // TODO handle http response codes
            guard let data = data, let photos = try? JSONDecoder().decode(T.self, from: data) else {
                self.finish(true)
                return
            }
            self.result = photos
            self.finish(true)
        }
        dataTask.resume()
    }
}

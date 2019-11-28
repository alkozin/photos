//
//  PhotosAPI.swift
//  Photos
//
//  Created by Alex Kozin on 26.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

class SearchPhotosAPI: HttpParamsPagedAPI<String, [Photo]> {

    override var path: String {
        return "search/photos"
    }

    override var parameters: [String : Any] {
        var parameters = super.parameters
        parameters["query"] = object

        return parameters
    }

    override func decoded() -> Any {
        let raw = super.decoded() as! [String: Any]
        return raw["results"]!
    }
}

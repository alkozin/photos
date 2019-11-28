//
//  PhotosAPI.swift
//  Photos
//
//  Created by Alex Kozin on 26.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

class PhotosAPI: HttpParamsPagedAPI<Nothing, [Photo]> {

    override var path: String {
        return "photos"
    }

}

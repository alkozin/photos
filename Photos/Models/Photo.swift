//
//  Repositorie.swift
//  Photos
//
//  Created by Alex Kozin on 18/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

@objcMembers
class Photo: BaseModel {

    var imageUrl: String!

    var urls: [String: String] {
        get {
            [:]
        }
        set {
            imageUrl = newValue["regular"]
        }
    }

    override class func propertyMapping() -> [String: String]? {
        return ["algorithm": "algorithmRawValue"]
    }
    
}

extension Photo: Item {
    
}

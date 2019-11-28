//
//  CloudKitParser.swift
//
//  Created by Alex Kozin on 13.05.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import CloudKit

class CloudKitParser: Parser {

    override func model(from raw: Any) -> APIModel {
        let model = type.init(raw as! CKRecord)
        return model
    }

}

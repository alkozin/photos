//
//  JsonDecoder.swift
//  Photos
//
//  Created by Alex Kozin on 25/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {

    class JsonDecoder: Decoder {

        override func decode(_ data: Data) -> Any {
            return try! JSONSerialization.jsonObject(with: data, options: [])
        }

    }

}

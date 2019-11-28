//
//  Encoding.swift
//  Photos
//
//  Created by Alex Kozin on 16/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {

    //TODO: Change to the protocol when nesting will be available.
    class Encoder {

        func encode( _ urlRequest: inout URLRequest, with parameters: [String: Any]?) {
            preconditionFailure("'encode' method should be overriden.")
        }

    }

}

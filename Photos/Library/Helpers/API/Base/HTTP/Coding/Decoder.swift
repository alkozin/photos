//
//  Decoder.swift
//  Photos
//
//  Created by Alex Kozin on 23/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {

    //TODO: Change to the protocol when nesting will be available.
    class Decoder {

        func decode(_ data: Data) -> Any {
            preconditionFailure("'decode' method should be overriden.")
        }
        
    }

}

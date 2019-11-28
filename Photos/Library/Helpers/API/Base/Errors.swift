//
//  Utils.swift
//  Photos
//
//  Created by Alex Kozin on 16/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {

    struct Errors {
        static let lastPageError = NSError(domain: "com.el-machine.api",
                                           code: 204,
                                           userInfo: ["message": "There is no more content"])
        static let operationError = NSError(domain: "com.el-machine.api",
                                            code: 205,
                                            userInfo: ["message": "Can't create operation"])
        static let userDiscoverabilityError = NSError(domain: "com.el-machine.api",
                                                      code: 206,
                                                      userInfo: ["message": "Can't discover user info"])
    }
    
}

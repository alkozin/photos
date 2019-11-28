//
//  PostAPI.swift
//  Photos
//
//  Created by Alex Kozin on 15/07/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

class PostAPI<O, R>: HttpAPI <O, R> {

    override var method: Method {
        return .POST
    }

}

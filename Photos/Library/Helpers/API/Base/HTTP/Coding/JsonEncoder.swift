//
//  JsonEncoding.swift
//  Photos
//
//  Created by Alex Kozin on 17/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {

    class JsonEncoder: Encoder {

        override func encode( _ urlRequest: inout URLRequest, with parameters: [String: Any]?) {
            guard let parameters = parameters else {
                return
            }

            let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])


            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        }
        
    }

}

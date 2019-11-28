//
//  URLEncoding.swift
//  Photos
//
//  Created by Alex Kozin on 16/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

extension APIInterface {
    
    class URLEncoder: Encoder {
        
        var inURL: Bool = true
        
        override func encode( _ urlRequest: inout URLRequest, with parameters: [String: Any]?) {
            guard let parameters = parameters else {
                return
            }
            
            if inURL {
                if var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                    let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                    urlComponents.percentEncodedQuery = percentEncodedQuery
                    urlRequest.url = urlComponents.url
                }
            } else {
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                }
                
                urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
            }
        }
        
        private func query(_ parameters: [String: Any]) -> String {
            var components: [(String, String)] = []
            
            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += queryComponents(fromKey: key, value: value)
            }
            return components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        
        private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
            var components: [(String, String)] = []
            
            if let dictionary = value as? [String: Any] {
                for (nestedKey, value) in dictionary {
                    components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
                }
            } else if let array = value as? [Any] {
                for value in array {
                    components += queryComponents(fromKey: "\(key)[]", value: value)
                }
            } else if let value = value as? NSNumber {
                if CFGetTypeID(value) == CFBooleanGetTypeID() {
                    components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
                } else {
                    components.append((escape(key), escape("\(value)")))
                }
            } else if let bool = value as? Bool {
                components.append((escape(key), escape((bool ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
            
            return components
        }
        
        private func escape(_ string: String) -> String {
            var allowedCharacterSet = CharacterSet.urlQueryAllowed
            allowedCharacterSet.remove(charactersIn: ":#[]@!$&'()*+,;=")
            
            return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        }
        
    }
    
}

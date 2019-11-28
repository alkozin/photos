//
//  ParSerKeyConvertor.swift
//  Photos
//
//  Created by Alex Kozin on 10/06/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

protocol ParserKeyConvertor {

    func converted(from stringKey: String) -> String
    func converted(from stringKey: String, capitlizeFirst: Bool) -> String
    
}

extension ParserKeyConvertor {

    func converted(from stringKey: String) -> String {
        return converted(from: stringKey, capitlizeFirst: false)
    }

}

extension Parser {

    struct DefaultConvertor: ParserKeyConvertor {

        func converted(from stringKey: String, capitlizeFirst: Bool) -> String {
            return stringKey
        }

    }

    struct SnakeCaseConvertor: ParserKeyConvertor {

         func converted(from stringKey: String, capitlizeFirst: Bool) -> String {
            var converted = self.converted(from: stringKey)
            if capitlizeFirst {
                converted = converted.first!.uppercased() + converted.dropFirst()
            }

            return converted
        }

        //From https://github.com/apple/swift/blob/master/stdlib/public/Darwin/Foundation/JSONEncoder.swift
        func converted(from stringKey: String) -> String {
            guard !stringKey.isEmpty else { return stringKey }

            // Find the first non-underscore character
            guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
                // Reached the end without finding an _
                return stringKey
            }

            // Find the last non-underscore character
            var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
            while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
                stringKey.formIndex(before: &lastNonUnderscore)
            }

            let keyRange = firstNonUnderscore...lastNonUnderscore
            let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
            let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

            let components = stringKey[keyRange].split(separator: "_")
            let joinedString : String
            if components.count == 1 {
                // No underscores in key, leave the word as is - maybe already camel cased
                joinedString = String(stringKey[keyRange])
            } else {
                joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
            }

            // Do a cheap isEmpty check before creating and appending potentially empty strings
            let result : String
            if (leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty) {
                result = joinedString
            } else if (!leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty) {
                // Both leading and trailing underscores
                result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
            } else if (!leadingUnderscoreRange.isEmpty) {
                // Just leading
                result = String(stringKey[leadingUnderscoreRange]) + joinedString
            } else {
                // Just trailing
                result = joinedString + String(stringKey[trailingUnderscoreRange])
            }
            return result
        }

    }

    
}

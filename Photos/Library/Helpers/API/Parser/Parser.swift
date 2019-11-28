//
//  Parser.swift
//  Photos
//
//  Created by Alex Kozin on 27.03.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

typealias APIModel = BaseModel

extension APIModel {

    @objc
    class func classMapping() -> [String: String]? {
        return nil
    }

    @objc
    class func propertyMapping() -> [String: String]? {
        return nil
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }

}

protocol APIParsed {

    static var type: APIModel.Type {get}

}

extension APIModel: APIParsed {

    static var type: APIModel.Type {
        return self
    }

}

extension Array: APIParsed where Element: APIModel {

    static var type: APIModel.Type {
        return Element.self
    }

}

private let executableName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String

class Parser {

    private var type: APIModel.Type

    private lazy var propertyMapping = type.propertyMapping() ?? [String: String]()
    private lazy var classMapping = type.classMapping() ?? [String: String]()

    let keyConvertor: ParserKeyConvertor = SnakeCaseConvertor()

    init(_ type: APIModel.Type) {
        self.type = type
    }

    ///  Parses reply to array of objects or object, entry point for parsing
    ///
    /// - Parameters:
    ///   - rawReply: object for parse (from backend)
    ///   - to: class for parsing
    /// - Returns: Array of objects or object
    func parsed(_ responce: Any?) -> Any {

        let parsed: Any
        switch responce {
        case let dictionary as [String: Any]:
            parsed = model(from: dictionary)
        case let array as [Any]:
            parsed = models(from: array)
        default:
            fatalError("'responce' can only be dictionary or array")
        }

        return parsed
    }

    /**
     Parses array of objects
     Calls objectFromDictionary: iteratively

     - parameter modelClass: Class for parsing data to
     - parameter array:      Array of dictionaries that represent an object

     - returns: Array of parsed objects
     */
    func models(from array: [Any]) -> [APIModel] {
        var models = [APIModel]()
        models.reserveCapacity(array.count)

        for object in array {
            models.append(model(from: object))
        }

        return models
    }

    /**
     Parses object with property values filled according to source object

     - parameter modelClass: Class for parsing data to
     - parameter source:     Source dictionary which represents object

     - returns: Parsed object
     */
    func model(from raw: Any) -> APIModel {
        let dictionary = raw as! [String: Any]

        let model = type.init()
        for (key, value) in dictionary {
            parseValue(model, value: value, forKey: key)
        }
        return model
    }

    func parseValue(_ model: APIModel, value: Any, forKey key: String) {

        // We should use mapping because some values should be saved to different keys
        // E.g. we should save value for key 'id' to key 'uid'
        // That's why we should use mapping
        // If key isn't exist in map we should convert it from backend representation
        // To our camel style
        
        // Try to find property name in mapping first
        var keyToSet = propertyMapping[key]
        if keyToSet == nil {
            // Convert key to property name
            keyToSet = keyConvertor.converted(from: key)

            // And save it to mapping
            propertyMapping[key] = keyToSet
        }

        // Try to find class in mapping first
        var className = classMapping[key]
        // If can't find
        if className == nil {
            // Convert key to class name
            className = keyConvertor.converted(from: key, capitlizeFirst: true)

            // And save it to mapping
            // Don't care it's class or not, just cache it to prevent converting again
            classMapping[key] = className
        }

        // Try to convert key to model class
        let valueToSet: Any?

        // Firstly we should check maybe key is some of our classes?
        if let objectClass = swiftClass(from: className!) as? APIModel.Type  {
            // If class exist, parse value to model

            valueToSet = Parser(objectClass).parsed(value)
        } else {
            // Otherwise just use value
            valueToSet = value
        }

        // And set value (parsed or not) to property
        model.setValue(valueToSet, forKey: keyToSet!)
    }

    private func swiftClass(from className: String) -> AnyClass? {
        return NSClassFromString(executableName + "." + className)
    }

}

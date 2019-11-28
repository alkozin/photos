//
//  Constants.swift
//  Photos
//
//  Created by Alex Kozin on 25.03.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

protocol Environment {

    var BaseURL: String? {get}
    var UnsplashAPIKey: String {get}

}

extension Environment {

    var UnsplashAPIKey: String {
        "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
    }

}

struct Constants {

    #if targetEnvironment(simulator)
            static let DevEnvironment = true
        #else
            #if DEBUG
                static let DevEnvironment = true
            #else
                static let DevEnvironment = false
            #endif
    #endif

    static var Environment: Environment {
        return DevEnvironment ? Dev() : Production()
    }

    struct Dev: Environment {

        var BaseURL: String? {
            "https://api.unsplash.com/"
        }

    }

    struct Production: Environment {

        var BaseURL: String? {
            fatalError()
        }

    }

    struct Development {

        struct LaunchScreenMode {
            static let enabled = false
        }

    }

    struct Errors {

    }

}

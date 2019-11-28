//
//  HttpAPI.swift
//  Photos
//
//  Created by Alex Kozin on 16/04/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

struct Http {

    static var defaultConfiguration: URLSessionConfiguration = {
        return URLSessionConfiguration.default
    }()

    static var defaultSession: URLSession = {
        return URLSession(configuration: defaultConfiguration)
    }()

}

enum Method: String {
    case GET
    case POST
    case HEAD
    case PUT
    case PATCH
    case DELETE
}

class HttpAPI<O, R>: API<O, R> {

    var session: URLSession {
        return Http.defaultSession
    }

    var baseURL: URL? {
        guard let urlString = Constants.Environment.BaseURL else {
            return nil
        }

        return URL(string: urlString)!
    }

    var path: String {
        preconditionFailure("'path' variable should be overriden. E.g. 'order/create'")
    }

    var absoluteURL: URL {
        return URL(string: path, relativeTo: baseURL)!
    }

    var method: Method {
        return .GET
    }

    var request: URLRequest {
        var request = URLRequest(url: absoluteURL,
                                 timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout

        return request
    }

    var lastHeaders: [AnyHashable: Any]?
    var task: URLSessionTask?

    override var inProgress: Bool {
        task != nil
    }

    func newEncoder() -> Encoder {
        return URLEncoder()
    }

    override func sendRequest() {
        var request = self.request
        newEncoder().encode(&request, with: parameters)

        let auth = "Client-ID " + Constants.Environment.UnsplashAPIKey
        request.setValue(auth, forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { (data, responce, error) in
            if let error = error ?? self.error(for: responce, data: data) {
                self.didFail(with: error)
            } else {
                self.didReturn((data!, responce))
            }
        }
        task.resume()

        self.task = task
    }

    override func didEnd() {
        self.task = nil
    }

    func error(for responce: URLResponse?, data: Data?) -> Error? {
        guard let httpResponce = responce as? HTTPURLResponse else {
            return NSError()
        }

        let code = httpResponce.statusCode
        if code != 200 {
            if let data = data, let decoded = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
                let message = decoded["message"] as! String
                return NSError(domain: "local",
                               code: code,
                               userInfo: [NSLocalizedFailureReasonErrorKey: message])
            } else {
                return NSError(domain: "local", code: code, userInfo: [NSLocalizedFailureReasonErrorKey: "Error"])
            }
        }

        return nil
    }

}

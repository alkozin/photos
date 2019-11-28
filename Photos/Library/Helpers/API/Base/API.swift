//
//  API.swift
//
// Created by Alexander Kozin https://github.com/alkozin
// Copyright (c) 2019 http://el-machine.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

typealias Nothing = Int8

class APIInterface {

    typealias ErrorHandler = (_ error: Error) -> ()
    typealias EndHandler = () -> ()

    typealias Progress = (_ progress: Double) -> ()
    typealias Reply = (data: Data, response: URLResponse?)

    var inProgress: Bool {
        preconditionFailure("\(#function) should be overriden. E.g. 'request != nil'")
    }

    func cancel() {
        preconditionFailure("\(#function) should be overriden. E.g. 'request.cancel()'")
    }

    func sendRequest() {
        preconditionFailure("\(#function) should be overriden.")
    }

    func didFail(with error: Error) {
         preconditionFailure("\(#function) should be overriden.")
    }

}

class API<O, R>: APIInterface {

    typealias Completion = (_ reply: R) -> ()

    var object: O!

    var completion: Completion?
    var errorHandler: ErrorHandler?

    var endHandler: EndHandler?

    var progress: Progress?

    var lastReply: Reply?
    var lastError: Any?

    var syncSemaphore: DispatchSemaphore?

    var parameters: [String: Any]? {
        //WARNING: This is a point to add any common data to all requests
        // E.g.access token
        //
        //var parameters = [String: Any]()
        //if (self.shouldAddAccessToken) {
        //    parameters["private_token"] = "inZfe4ogw91KZSY4U1Gy"
        //}

        return nil
    }

    var timeout: TimeInterval {
        return 15.0
    }

    //Additional init for 'completion' trailing closure
    @discardableResult
    convenience init(_ object: O? = nil, completion: Completion? = nil) {
        self.init(object, completion: completion, error: nil, end: nil)
    }

    @discardableResult
    init(_ object: O? = nil, completion: Completion? = nil, error: ErrorHandler? = nil, end: EndHandler? = nil) {
        super.init()
        
        self.object = object

        prepare()

        if let completion = completion {
            call(with: completion, error: error, end: end)
        }
    }

    func prepare() {
    }

    func sync() -> Self {
        if syncSemaphore == nil {
            syncSemaphore = DispatchSemaphore(value: 0)
        }

        return self
    }

    func call(with completion: @escaping Completion, error: ErrorHandler?, end: EndHandler?) {
        self.completion = completion
        self.errorHandler = error
        self.endHandler = end

        sendRequest()

        _ = syncSemaphore?.wait(timeout: DispatchTime.now() + timeout)
    }

    func didReturn(_ reply: Reply) {
        lastError = nil
        lastReply = reply

        if let completion = self.completion {
            let parsedReply = self.parsedReply()
            completion(parsedReply)
        }

        didEnd()
    }

    func parsedReply() -> R {
        if R.self is Nothing.Type {
            return Nothing() as! R
        }

        let reply: R

        let decoded = self.decoded()

        if let parser = newParser() {
            reply = parser.parsed(decoded) as! R
        } else if let decoded = decoded as? R  {
            reply = decoded
        } else {
            preconditionFailure("Default Parser supports only APIParsed objects. Override 'newParser()' or parsedReply()")
        }

        return reply
    }

    func decoded() -> Any {
        return newDecoder().decode(lastReply!.data)
    }

    func newDecoder() -> Decoder {
        return JsonDecoder()
    }

    func newParser() -> Parser? {
        guard let parsedType = (R.self as? APIParsed.Type)?.type else {
            return nil
        }

        return Parser(parsedType)
    }

    override func didFail(with error: Error) {
        lastReply = nil
        lastError = error

        if let errorHandler = self.errorHandler {
            errorHandler(error)
        } else {
            MessageCenter.showError(error)
        }

        didEnd()
    }

    func didEnd() {
        endHandler?()
        syncSemaphore?.signal()
    }

}

extension API: CustomDebugStringConvertible {

    var debugDescription: String {
        return "\(String(describing: self)) object: \(String(describing: object))"
    }

}

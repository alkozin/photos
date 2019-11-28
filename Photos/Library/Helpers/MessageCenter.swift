//
//  MessageCenter.swift
//  Photos
//
//  Created by Alex Kozin on 02.06.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

class MessageCenter: NSObject {

    /// Shows message view to user
    ///
    /// - Parameter message: Message text
    static func showMessage(_ message: String) {
        if (!message.isEmpty) {
            showAlertView(withTitle: nil, andMessage: message)
        }
    }

    /// Shows error message to user if 'error' exist
    /// Calls showErrorIfExist:error:otherwisePerform: internally
    ///
    /// - Parameter error: Error object for generating a message
    static func showError(_ error: Error?) {
        showErrorIfExist(error, otherwisePerform: nil)
    }

    /// Shows error message to user if 'error' exist, otherwise invoke 'block'
    /// Calls +showErrorIfExist:error:otherwisePerform: internally
    ///
    /// - Parameters:
    ///   - error: Error object for generating a message
    ///   - block: Handler if error is nil
    static func showErrorIfExist(_ error: Error?, otherwisePerform block: (() -> ())?) {
        showErrorIfExist(error, errorBlock: nil, otherwisePerform: block)
    }

    /// Shows error message to user if 'error' exist and invoke 'errorBlock', otherwise invoke 'block'
    ///
    /// - Parameters:
    ///   - error: Error object for generating a message
    ///   - errorBlock: Handler if error is exist
    ///   - block: Handler if error is nil
    static func showErrorIfExist(_ error: Error?, errorBlock:  (() -> ())?, otherwisePerform block: (() -> ())?) {
        if let error = error {
            if shouldShowRealErrorToUser(error as NSError)  {
                showRealErrorAlertView(error)
            } else {
                showHostNotReachableError()
            }

            if let errorBlock = errorBlock {
                errorBlock()
            }
        } else if let block = block {
            block()
        }
    }

    static func showHostNotReachableError() {
        showAlertView(withTitle: localizedString("Common.hostNotReachable.title"),
                      andMessage: localizedString("Common.hostNotReachable.message"))
    }

    static func showAlertView(withTitle title: String?, andMessage message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: localizedString("Common.ok"),
                                             style: .cancel,
                                             handler: nil))

        dispatchMainSyncSafe {
            UIApplication.shared.visibleViewController()?.present(controller, animated: true, completion: nil)
        }
    }

    static func showRealErrorAlertView(_ error: Error?) {
        if let message = messageForError(error) {
            showAlertView(withTitle: nil, andMessage: message)
        }
    }

    static func shouldShowRealErrorToUser(_ error: NSError) -> Bool {
        #if DEBUG
            return true
        #else
        return error.code == 300
        #endif
    }

    static func messageForError(_ error: Error?) -> String? {
        let message: String?
        if let error = error {
            message = error.localizedDescription
        } else {
            message = nil
        }

        return message
    }

    private static func dispatchMainSyncSafe(_ block:  () -> Void) {
        if (Thread.isMainThread) {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }

    private static func localizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

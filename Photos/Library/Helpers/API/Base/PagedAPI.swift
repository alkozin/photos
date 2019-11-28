//
//  PagedAPI.swift
//  Photos
//
//  Created by Alex Kozin on 27.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

protocol PagedAPI: APIInterface {

    var isFirstPage: Bool {get}
    var isLastPage: Bool {get}

    var objectsPerPage: Int {get}
    var limitParameterName: String {get}

    func resetToFirstPage()
}

extension PagedAPI {

    var limitParameterName: String {
        return "_limit"
    }

    func requestNextPage() {
        if !inProgress {
            if isLastPage {
                didFail(with: Errors.lastPageError)
            } else {
                sendRequest()
            }
        } else {
        }
    }

    func requestFromFirstPage() {
        cancel()
        resetToFirstPage()
        requestNextPage()
    }

}

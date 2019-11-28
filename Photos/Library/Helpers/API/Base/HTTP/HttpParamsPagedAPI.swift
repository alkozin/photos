//
//  HttpParamsPagedAPI.swift
//  Photos
//
//  Created by Alex Kozin on 27.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

class HttpParamsPagedAPI<O, R>: HttpAPI<O, R>, PagedAPI {

    let firstPageNumber = 1
    let offsetName = "page"
    let limitName = "per_page"

    lazy var offset = firstPageNumber

    var isLastPage: Bool = false

    override var parameters: [String : Any] {
        [offsetName: offset,
         limitName: objectsPerPage]
    }

    var isFirstPage: Bool {
        return offset == firstPageNumber
    }

    var objectsPerPage: Int {
        return 30
    }

    func resetToFirstPage() {
        offset = firstPageNumber
        isLastPage = false
    }

    override func parsedReply() -> R {
        let r = super.parsedReply()

        let array = r as! [Any]
        didRecieveObjects(count: array.count)

        return r
    }

    func didRecieveObjects(count: Int) {
        offset += 1
        isLastPage = count < objectsPerPage
    }

}

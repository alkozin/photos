//
//  FileReplyAPI.swift
//  Photos
//
//  Created by Alex Kozin on 22/06/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import Foundation

protocol FileReplyAPI {

    func didReturn(_ reply: APIInterface.Reply)
    func returnReplyFromFile()

}

extension FileReplyAPI {

    func returnReplyFromFile() {
        let fileName = String(describing: type(of: self))
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        let data = try! Data(contentsOf: url)

        self.didReturn((data, nil))
    }

}

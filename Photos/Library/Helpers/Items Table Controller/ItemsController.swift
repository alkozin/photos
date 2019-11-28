//
//  ItemsTableController.swift
//  Photos
//
//  Created by Alex Kozin.
//  Copyright (c) 2013 General Rhetoric Ltd. All rights reserved.
//

import UIKit

class ItemsController<T: Item>: ViewController {

    var items = [T]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        clearSelection()
    }

    func clearSelection() {

    }

    @objc
    func reloadItems() {

    }

    func reloadView() {

    }

}

//
//  PrefetchTableItemsController.swift
//  Photos
//
//  Created by Alex Kozin on 27/05/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

class PrefetchingTableItemsController<T: Item>: TableItemsController<T>, UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        requestNextPage()
    }

    func requestNextPage() {

    }

}

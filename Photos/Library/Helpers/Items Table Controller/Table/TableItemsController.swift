//
//  Table.swiftItemsController.swift
//  Photos
//
//  Created by Alex Kozin on 03/07/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

class TableItemsController<T: Item>: ItemsController<T>, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    lazy var refreshControl: UIRefreshControl? = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareRefreshControl()
    }

    func prepareRefreshControl() {
        tableView.addSubview(refreshControl!)
        refreshControl!.addTarget(self, action: #selector(reloadItems), for: .valueChanged)
    }

    override func clearSelection() {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }

    override func reloadView() {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let identifier = item.cellIdentifier ?? "Cell"

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as! TableItemCell<T>
        cell.item = item

        return cell
    }

    //All items are same height, using rowHeight in IB instead
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return items[indexPath.row].height
    //    }

}

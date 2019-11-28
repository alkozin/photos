//
//  CollectionItemsController.swift
//  Photos
//
//  Created by Alex Kozin on 03/07/2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

class CollectionItemsController<T: Item>: ItemsController<T>, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    override func reloadView() {
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let identifier = item.cellIdentifier ?? "Cell"

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! CollectionViewItemCell<T>
        cell.item = item

        return cell
    }

}

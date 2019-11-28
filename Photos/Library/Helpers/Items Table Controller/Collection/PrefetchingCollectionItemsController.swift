//
//  PrefetchingCollectionItemsController.swift
//  Photos
//
//  Created by Alex Kozin on 26.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit.UICollectionView

class PrefetchingCollectionItemsController<T: Item>: CollectionItemsController<T>, UICollectionViewDelegateFlowLayout {

    //Using willDisplay is more efficent than prefetching
    //Because prefetching don't calls after reloading collection view
    //And indexPathsForVisibleItems not sorted
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        requestItem(at: indexPath)
    }

    func requestItem(at indexPath: IndexPath) {

    }

}




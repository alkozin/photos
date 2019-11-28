//
//  TableItemCell.swift
//  Photos
//
//  Created by Alex Kozin.
//  Copyright (c) 2013 General Rhetoric Ltd. All rights reserved.
//

import UIKit

import SwipeCellKit

protocol ItemCell  {
    associatedtype T

    var item: T? {get set}
    func showItem()

}

class TableItemCell<T>: UITableViewCell, ItemCell {

    var item: T? {
        didSet {
            showItem()
        }
    }

    func showItem() {
    }

}

class CollectionViewItemCell<T>: SwipeCollectionViewCell, ItemCell {

    var item: T? {
        didSet {
            showItem()
        }
    }

    func showItem() {
    }

}


//
//  Item.swift
//  Photos
//
//  Created by Alex Kozin.
//  Copyright (c) 2013 General Rhetoric Ltd. All rights reserved.
//

import UIKit.UITableView

protocol Item {

    var cellIdentifier: String? {get}
    var height: CGFloat {get}
    
}

extension Item {

    var cellIdentifier: String? {
        return nil
    }

    var height: CGFloat {
        return UITableView.automaticDimension
    }
    
}

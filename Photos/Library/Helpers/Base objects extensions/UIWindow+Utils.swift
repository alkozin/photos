//
//  RootViewController.swift
//  Photos
//
//  Created by Alex Kozin on 19.06.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

extension UIViewController {

    @objc
    var visible: UIViewController {
        return presentedViewController?.visible ?? self
    }

}

extension UINavigationController {

    @objc
    override var visible: UIViewController {
        return visibleViewController?.visible ?? self
    }

}

extension UIApplication {

    func visibleViewController() -> UIViewController? {
        return keyWindow?.rootViewController?.visible
    }

}

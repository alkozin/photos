//
//  UIScrollView+Utils.swift
//  Photos
//
//  Created by Alex Kozin on 31.05.16.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

extension UIScrollView {

    func scrollToTop(_ animated: Bool) {
        let offset = CGPoint(x: 0.0, y: -contentInset.top)
        setContentOffset(offset, animated: true)
    }

    func maxContentOffset() -> CGPoint {
        let size = frame.size;

        let maxContentOffsetX = contentSize.width < size.width ? 0.0 : contentSize.width - size.width;
        let maxContentOffsetY = contentSize.height < size.height ? 0.0 : contentSize.height - size.height;

        return CGPoint(x: maxContentOffsetX + contentInset.left + contentInset.right,
                           y: maxContentOffsetY + contentInset.top + contentInset.bottom);
    }

    func scrollToMaxOffsetAnimated(_ animated: Bool) {
        setContentOffset(maxContentOffset(), animated: true)

    }
}

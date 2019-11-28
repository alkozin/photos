//
//  PhotoGridCell.swift
//  Photos
//
//  Created by Alex Kozin on 27.11.2019.
//  Copyright © 2019 Alex Kozin. All rights reserved.
//

import UIKit

import Kingfisher

class PhotoCell: CollectionViewItemCell<Photo> {

    @IBOutlet var imageView: UIImageView!

    var downloadTask: DownloadTask?

    override func prepareForReuse() {
        imageView.image = nil
        downloadTask?.cancel()
    }

    override func showItem() {
        guard let imageUrlString = item?.imageUrl else {
            imageView.image = nil

            return
        }

        let url = URL(string: imageUrlString)!
        downloadTask = imageView.kf.setImage(with: url)
    }

}

//
//  CollectionViewCell.swift
//  CollectionViewExample
//
//  Created by Lynne Okada on 2017/08/08.
//  Copyright © 2017 Lynne Okada. All rights reserved.
//

import UIKit
import Photos

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    let imgManager = PHImageManager.default()
    
    var requestId: PHImageRequestID?
    
    var albumImage: AlbumImage? {
        didSet {
            guard let album = albumImage else {
                return
            }
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            requestId = imgManager.requestImage(for: album.asset , targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFill, options: requestOptions, resultHandler: { [weak self] image, info in
                self?.userImage.image = image
            })
        }
    }
    
    override func prepareForReuse() {
        if let id = requestId {
            imgManager.cancelImageRequest(id)
        }
    }
}

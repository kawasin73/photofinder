//
//  PhotoViewControllerDetail.swift
//  PhotoFinder
//
//  Created by ビデオエイペックス on 2017/08/09.
//  Copyright © 2017 Ai. All rights reserved.
//

import Foundation

import UIKit

class PhotoViewControllerDetail: UIViewController {
    
    @IBOutlet weak var PhotoViewDetails: UIImageView!
    
    

    var photo: UIImage?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let image = photo {
            PhotoViewDetails.image = image
        }
}
}

//
//  PhotoViewController.swift
//  PhotoFinder
//
//  Created by ビデオエイペックス on 2017/08/09.
//  Copyright © 2017 Ai. All rights reserved.
//

import Foundation

import UIKit
import Photos

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var photoView : UIImageView!
    @IBOutlet weak var keywordTextfield : UITextField!
    
    let userDefaults = UserDefaults.standard
    
    let imgManager = PHImageManager.default()
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        print("KEY:", album?.id ?? "NONE")
        print("VALUE:", keywordTextfield.text ?? "NONE")
        userDefaults.setValue(keywordTextfield.text, forKeyPath: album?.id ?? "NONE")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    var album: AlbumImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordTextfield.delegate = self
        if let album = album {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            imgManager.requestImage(for: album.asset , targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFill, options: requestOptions, resultHandler: { [weak self] image, info in
                self?.photoView.image = image
            })
            if let text = userDefaults.value(forKey: album.id ) as? String {
                keywordTextfield.text = text
            }
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextfield.resignFirstResponder()
        return true
    }
    
}

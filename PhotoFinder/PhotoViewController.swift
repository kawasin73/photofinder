//
//  PhotoViewController.swift
//  PhotoFinder
//
//  Created by ビデオエイペックス on 2017/08/09.
//  Copyright © 2017 Ai. All rights reserved.
//

import Foundation

import UIKit

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var photoView : UIImageView!
    @IBOutlet weak var keywordTextfield : UITextField!
    
    let userDefaults = UserDefaults.standard
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
        print("KEY:", album?.id ?? "NONE")
        print("VALUE:", keywordTextfield.text ?? "NONE")
        userDefaults.setValue(keywordTextfield.text, forKeyPath: album?.id ?? "NONE")
        self.dismiss(animated: true, completion: nil)
    }

    var album: AlbumImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordTextfield.delegate = self
        if let album = album {
            photoView.image = album.image
            if let text = userDefaults.value(forKey: album.id ?? "NONE") as? String {
                keywordTextfield.text = text
            }
        }
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextfield.resignFirstResponder()
        return true
    }
    
}

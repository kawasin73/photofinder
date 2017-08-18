//
//  ViewController.swift
//  CollectionViewExample
//
//  Created by Lynne Okada on 2017/08/08.
//  Copyright © 2017 Lynne Okada. All rights reserved.
//

import UIKit
import Photos

struct AlbumImage {
    let asset: PHAsset
    let id: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    var imageArray = [AlbumImage]()
    var showImageArray = [AlbumImage]()
    var selectedAlbum : AlbumImage?
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.searchBar.delegate = self
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            NSLog("start request")
            PHPhotoLibrary.requestAuthorization { status in
                self.grabPhotos()
            }
        } else {
            grabPhotos()
        }
        
        self.photoCollectionView.reloadData()
        
        print(userDefaults.dictionaryRepresentation())
    }
    
    
    func filterImages(text: String?) {
        guard let text = text else {
            print("text is nil")
            showImageArray = imageArray
            photoCollectionView.reloadData()
            return
        }
        if text == "" {
            print("text is blank")
            showImageArray = imageArray
            photoCollectionView.reloadData()
            return
        }
        print("searching")
        showImageArray.removeAll()
        photoCollectionView.reloadData()
        for (key, value) in userDefaults.dictionaryRepresentation() {
            if let str = value as? String, str.contains(text) {
                if let album = findImage(key: key) {
                    showImageArray.append(album)
                }
            }
        }
        photoCollectionView.reloadData()
    }
    
    func findImage(key: String) -> AlbumImage? {
        for album in imageArray {
            if album.id == key {
                return album
            }
        }
        return nil
    }
    
    func grabPhotos() {
        let fetchOptions = PHFetchOptions()
//        let date = NSDate(timeIntervalSinceNow: -30*24*60*60)
// 　      fetchOptions.predicate = NSPredicate(format: "creationDate > %@", date)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
       
        let assets:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        assets.enumerateObjects({ asset, idx, stop in
            let album = AlbumImage(asset: asset, id: asset.localIdentifier)
            self.imageArray.append(album)
            self.showImageArray.append(album)
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked: \(String(describing: searchBar.text))")
        filterImages(text: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange: \(searchText)")
        filterImages(text: searchText)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.album = self.selectedAlbum
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        self.selectedAlbum = showImageArray[row]
        self.performSegue(withIdentifier: "showImage", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(showImageArray.count)
        return showImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraCell", for: indexPath)
        if let cell = cell as? CollectionViewCell {
            cell.albumImage = showImageArray[indexPath.row]
        }
        return cell
    }
    
}


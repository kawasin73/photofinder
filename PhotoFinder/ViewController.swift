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
    let image: UIImage?
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
    
    
    
    
    
//    // MARK:- prepareForSegue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // retrieve selected cell &amp; fruit
//        if let indexPath = getIndexPathForSelectedCell() {
//            
//            let fruit = dataSource.fruitsInGroup(indexPath.section)[indexPath.row]
//            
//            let detailViewController = segue.destination as! DetailViewController
//            detailViewController.fruit = fruit
//        }
//    }
//    
//    func getIndexPathForSelectedCell() -&gt; NSIndexPath? {
//    
//    var indexPath:NSIndexPath?
//    
//    if collectionView.indexPathsForSelectedItems().count &gt; 0 {
//    indexPath = collectionView.indexPathsForSelectedItems()[0] as? NSIndexPath
//    }
//    return indexPath
//    }
    
    
    
    
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        // 選択した写真を取得する
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        // ビューに表示する
//        self.imageView.image = image
//        // 写真を選ぶビューを引っ込める
//        self.dismiss(animated: true)
//    }
    
    
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
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
//        let date = NSDate(timeIntervalSinceNow: -30*24*60*60)
// 　      fetchOptions.predicate = NSPredicate(format: "creationDate > %@", date)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
       
        let assets:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        assets.enumerateObjects({ asset, idx, stop in
            imgManager.requestImage(for: asset , targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                image, info in
                let album = AlbumImage(image: image, id: asset.localIdentifier)
                self.imageArray.append(album)
                self.showImageArray.append(album)
            })
        })
//        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions) {
//            if fetchResult.count > 0 {
//                for i in 0..<fetchResult.count {
//                    imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 250, height: 250), contentMode: .aspectFill, options: requestOptions, resultHandler: {
//                        image, info in
//                        if let url: URL = info?["PHImageFileURLKey"] as? URL {
//                            print(info ?? "NONE")
//                            self.imageArray.append(AlbumImage(image: image, url: url))
//                        }
//                    })
//                }
//            } else {
//                print("You have no photos")
//                self.photoCollectionView.reloadData()
//            }
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked: \(searchBar.text)")
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
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let image = showImageArray[indexPath.row]
        imageView.image = image.image
        
        return cell
    }
    
}


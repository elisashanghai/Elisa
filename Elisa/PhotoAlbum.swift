//
//  PhotoAlbum.swift
//  Elisa
//
//  Created by Yang Song on 8/19/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "App Folder1"
let myScreen = UIScreen()

class PhotoAlbum: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var albumFound: Bool = false
    var assetColletion: PHAssetCollection?
    var photoAsset: PHFetchResult?
    var assetThumbnailSize:CGSize!
    var dict: [NSObject : AnyObject]?
    
    //Actions & Outlets
    @IBOutlet weak var panoramaCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Check if panoramas exist, if not show warning
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumPanoramas, options: nil)
        if(collection.firstObject != nil){
            //found the album
            self.albumFound = true
            self.assetColletion = collection.firstObject as? PHAssetCollection
        }else{
            print("no panoramas")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Get size of the collectionView cell for thumbnail image
        if let layout = self.panoramaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
            
            
            //fetch the photos from collection
            self.navigationController?.hidesBarsOnTap = false
            self.photoAsset = PHAsset.fetchAssetsInAssetCollection(self.assetColletion!, options: nil)
            
            //Handle no photos in the assetCollection
            //...Have a label that says "No Photos"
            
            self.panoramaCollectionView.reloadData()
        }
    }
    
    func metadata(asset: PHAsset) {
        // get photo info from this asset
        let imageRequestOptions: PHImageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.synchronous = true
        let manager = PHImageManager.defaultManager()
        
        manager.requestImageDataForAsset(asset, options: imageRequestOptions) {(imageData, dataUTI, orientation, info) -> Void in
            self.dict = self.metadataFromImageData(imageData!)!
            print(self.dict)
        }
    }
    
    
    
    
    func metadataFromImageData(imageData: NSData) -> [NSObject : AnyObject]? {
        guard let imageSource = CGImageSourceCreateWithData((imageData as CFDataRef), nil) else {
            return nil
        }
        
        let kCGImageSourceShouldCacheString = kCGImageSourceShouldCache as String
        let options = [kCGImageSourceShouldCacheString : NSNumber(bool: false)] as CFDictionaryRef
        
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options) else {
            return nil
        }
        
        let metadata = imageProperties as Dictionary
        return metadata
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewSinglePhoto"){
            let controller: EditingViewController = segue.destinationViewController as! EditingViewController
            let indexPath: NSIndexPath = self.panoramaCollectionView.indexPathForCell(sender as! UICollectionViewCell)!
            let asset = self.photoAsset![indexPath.item] as? PHAsset
            controller.asset = asset
            self.metadata(asset!)
            controller.dict = self.dict
        }
    }

    //UICollectionViewDataSource Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if self.photoAsset != nil{
            count = self.photoAsset!.count
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell: PhotoThumbnail = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoThumbnail
        //Modify the cell
        let asset = self.photoAsset![indexPath.item] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: assetThumbnailSize, contentMode: .AspectFill, options: nil, resultHandler: {
            (result,info)in
            cell.setThumbnailImage(result!)
        })
        return cell
    }

  

}

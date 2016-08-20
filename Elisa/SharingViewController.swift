//
//  SharingViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import ImageIO
import Photos
import MobileCoreServices
import AssetsLibrary

class SharingViewController: UIViewController {
    var mySelectedFilter = Filter?()
    var photoToEdit: UIImage?
    var dict: [NSObject : AnyObject]?
    var filteredPhoto: UIImage?
    var myImageSource: CGImageSource?
    var asset: PHAsset?
    var filteredPreview: UIImage?
    var didShared: Bool = false

    

//    @IBOutlet weak var facebookButton: UIButton!
    
//    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var camerarollButton: UIButton!
    @IBOutlet weak var filteredPhotoImageView: UIImageView!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    
//    @IBAction func buttonFacebookTapped(sender: AnyObject) {
//        facebookButton.setImage(UIImage(named: "facebook-finished"), forState: UIControlState.Normal)
//        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        composeSheet.setInitialText("Hello, Facebook!")
//        composeSheet.addImage(filteredPhoto)
//        
//        presentViewController(composeSheet, animated: true, completion: nil)
//    }
//    
//    @IBAction func buttonTwitterTapped(sender: AnyObject) {
//        twitterButton.setImage(UIImage(named: "twitter-finished"), forState: UIControlState.Normal)
//        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//        composeSheet.setInitialText("Hello, Twitter!")
//        composeSheet.addImage(filteredPhoto)
//        
//        presentViewController(composeSheet, animated: true, completion: nil)
//
//    }
    
    @IBAction func buttonRatingTapped(sender: AnyObject) {
        ratingButton.setImage(UIImage(named: "like-finished"), forState: UIControlState.Normal)
        if let url = NSURL(string: "https://www.facebook.com/filter360") {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    
    @IBAction func buttonCameraRollTapped(sender: AnyObject) {
        if didShared == false {

            
            self.photoToEdit = self.getAssetFullImage(self.asset!)
            
            if self.mySelectedFilter == nil {
                self.filteredPhoto = self.photoToEdit
            }
            else {
                self.filteredPhoto = self.mySelectedFilter!.applyFilter(self.photoToEdit!, filterType: self.mySelectedFilter!.filterType)}
            print("filteredPhoto size: \(self.filteredPhoto?.size.width)")
        camerarollButton.setImage(UIImage(named: "ios_photos-finished"), forState: UIControlState.Normal)
            
//        ALAssetsLibrary methods (work)
        let library: ALAssetsLibrary = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(filteredPhoto?.CGImage, metadata: dict, completionBlock: nil)
            print(dict)}
        didShared = true

    }
    

    
    
    func getAssetFullImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var fullImage = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            fullImage = result!
        })
        return fullImage
    }
 
    func frameReadyToSave(image: UIImage, withExifAttachments mutableDict: [NSObject : AnyObject]) {
        let imageData: NSData = UIImageJPEGRepresentation(image, 1.0)!
        let source: CGImageSourceRef = CGImageSourceCreateWithData((imageData as CFDataRef), nil)!
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.PicturesDirectory, .UserDomainMask, true)[0];
        let filePath="\(documentsPath)/";
        let tmpURL: NSURL = NSURL.fileURLWithPath(filePath)
        
        //modify to your needs
        let destination: CGImageDestinationRef = CGImageDestinationCreateWithURL((tmpURL as CFURLRef), kUTTypeJPEG, 1, nil)!
        CGImageDestinationAddImageFromSource(destination, source, 0, (mutableDict as CFDictionaryRef))
        CGImageDestinationFinalize(destination)
//        CFRelease(source)
//        CFRelease(destination)
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromImageAtFileURL(tmpURL)
            }, completionHandler: {(success: Bool, error: NSError?) -> Void in
                //cleanup the tmp file after import, if needed
                //cleanup the tmp file after import, if needed
        })
    }
    
 
    
    @IBAction func dismissSegueInSharingView(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filteredPhotoImageView.image = filteredPreview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filteredPhotoTapped))
        filteredPhotoImageView.userInteractionEnabled = true
        filteredPhotoImageView.addGestureRecognizer(tapGestureRecognizer)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "sharingToPhotoView"){
            let toPhotoView = segue.destinationViewController as! PhotoViewController
            toPhotoView.filteredPhoto = filteredPreview
            toPhotoView.asset = asset
            toPhotoView.mySelectedFilter = mySelectedFilter
//            toPhotoView.filteredPhoto = filteredPhoto
        }
    }
    
    func filteredPhotoTapped() {
        performSegueWithIdentifier("sharingToPhotoView", sender: nil)
        
    }


}

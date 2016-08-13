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
    }

    
    
    @IBAction func buttonCameraRollTapped(sender: AnyObject) {
        camerarollButton.setImage(UIImage(named: "ios_photos-finished"), forState: UIControlState.Normal)
        
        
        
        
        
//        ALAssetsLibrary methods (work)
        let library: ALAssetsLibrary = ALAssetsLibrary()
        library.writeImageToSavedPhotosAlbum(filteredPhoto?.CGImage, metadata: dict, completionBlock: nil)
        print(dict)
       
        
        
        /* ImageIO methods(not working)
        
        let UTI = CGImageSourceGetType(myImageSource!)! as CFStringRef
        let imageData: NSMutableData = NSMutableData()
        let destination: CGImageDestination? = CGImageDestinationCreateWithData(imageData, UTI, 1, nil)
        if destination == nil{
            NSLog("***Could not create image destination ***")
        }
        
        CGImageDestinationAddImageFromSource(destination!, myImageSource!, 0, dict)
        
        var success: Bool = false
        success = CGImageDestinationFinalize(destination!)
        
        if success == false {
        NSLog("***Could not create data from image destination ***")
        }else{
        print("Final properties \(dict)")
        }
 
 */
//    frameReadyToSave(filteredPhoto!, withExifAttachments: dict!)
        
//        print(dict)
        
        
        
//        UIImageWriteToSavedPhotosAlbum(filteredPhoto!, nil, nil, nil)
    }
    
    /*
    PHFetchResult *savedAssets = [PHAsset fetchAssetsWithLocalIdentifiers:[NSArray arrayWithObjects:myAssetURL, nil] options:nil];
    [savedAssets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
    PHImageRequestOptions *cropToSquare = [[PHImageRequestOptions alloc] init];
    cropToSquare.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
    options:cropToSquare
    resultHandler:
    ^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
    CIImage* ciImage = [CIImage imageWithData:imageData];
    NSMutableDictionary *metadataAsMutable = [ciImage.properties mutableCopy];
    CGImageSourceRef source = Nil;
    NSDictionary* sourceOptionsDict = [NSDictionary dictionaryWithObjectsAndKeys:dataUTI ,kCGImageSourceTypeIdentifierHint,nil];
    source = CGImageSourceCreateWithData((__bridge CFDataRef) imageData,  (__bridge CFDictionaryRef) sourceOptionsDict);
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
    }
    [dest_data writeToFile:myTrumbImageFileName atomically:YES];
    CFRelease(destination);
    CFRelease(source);
    }];
    }];
    */
    
    
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
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            self.photoToEdit = self.getAssetFullImage(self.asset!)
            
            if self.mySelectedFilter == nil {
                self.filteredPhoto = self.photoToEdit
            }
            else {
                self.filteredPhoto = self.mySelectedFilter!.applyFilter(self.photoToEdit!, filterType: self.mySelectedFilter!.filterType)}
            print("filteredPhoto size: \(self.filteredPhoto?.size.width)")
            
        }

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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

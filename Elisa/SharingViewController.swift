//
//  SharingViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import Social
import ImageIO
import Photos
import CoreImage
import MobileCoreServices

class SharingViewController: UIViewController {
    var mySelectedFilter = Filter?()
    var photoToEdit: UIImage?
    var dict: [NSObject : AnyObject]?
    var filteredPhoto: UIImage?
    var myImageSource: CGImageSource?
    

    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var camerarollButton: UIButton!
    @IBOutlet weak var filteredPhotoImageView: UIImageView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBAction func buttonFacebookTapped(sender: AnyObject) {
        facebookButton.setImage(UIImage(named: "facebook-finished"), forState: UIControlState.Normal)
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        composeSheet.setInitialText("Hello, Facebook!")
        composeSheet.addImage(filteredPhoto)
        
        presentViewController(composeSheet, animated: true, completion: nil)
    }
    
    @IBAction func buttonTwitterTapped(sender: AnyObject) {
        twitterButton.setImage(UIImage(named: "twitter-finished"), forState: UIControlState.Normal)
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        composeSheet.setInitialText("Hello, Twitter!")
        composeSheet.addImage(filteredPhoto)
        
        presentViewController(composeSheet, animated: true, completion: nil)

    }
    
    @IBAction func buttonRatingTapped(sender: AnyObject) {
        ratingButton.setImage(UIImage(named: "like-finished"), forState: UIControlState.Normal)
    }

    
    
    @IBAction func buttonCameraRollTapped(sender: AnyObject) {
        camerarollButton.setImage(UIImage(named: "ios_photos-finished"), forState: UIControlState.Normal)

        
        
//        print(dict)
//        frameReadyToSave(filteredPhoto!, withExifAttachments: dict!)
        
        
        
        UIImageWriteToSavedPhotosAlbum(filteredPhoto!, nil, nil, nil)
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
        if mySelectedFilter == nil {
            filteredPhoto = photoToEdit
        }
        else {
            filteredPhoto = mySelectedFilter!.applyFilter(photoToEdit!, filterType: mySelectedFilter!.filterType)}
        filteredPhotoImageView.image = filteredPhoto
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
            toPhotoView.filteredPhoto = filteredPhoto
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

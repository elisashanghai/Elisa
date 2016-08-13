//
//  UploadPhotoViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/4/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO
import Photos



class UploadPhotoViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    
    let initialImage = UIImage(named: "initial image")
    var dict: [NSObject : AnyObject]?
    var asset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uploadImageView.image = initialImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(initialPhotoTapped))
        uploadImageView.userInteractionEnabled = true
         uploadImageView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func initialPhotoTapped() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
        }
        
    }
    


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
 
        /*
//        photoToEdit = image
//        let nsurl = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
//        let cfurl = CFBridgingRetain(nsurl) as! CFURLRef
//        
//        
//        var myImageSource = CGImageSourceCreateWithURL(cfurl, nil)
//        var imagePropertiesDictionary: CFDictionaryRef
//        imagePropertiesDictionary = CGImageSourceCopyPropertiesAtIndex(myImageSource!, 0, nil)!
////        var imageLensMake = (CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyExifLensMake))
//        
//        var imageWidth: CFNumberRef = (CFDictionaryGetValue(imagePropertiesDictionary, kCGImagePropertyPixelWidth) as! CFNumberRef)
//        let exifDict = NSMutableDictionary()
//        exifDict.setObject("abc", forKey: kCGImagePropertyExifLensMake as String)   //エラー1
//        
//        print(exifDict)
//        var imageData: NSMutableData = NSMutableData()
//        var dest: CGImageDestinationRef = CGImageDestinationCreateWithData(imageData, CGImageSourceGetType(source!)!, 1, nil)!
//        CGImageDestinationAddImageAndMetadata(dest, <#T##image: CGImage##CGImage#>, <#T##metadata: CGImageMetadata?##CGImageMetadata?#>, <#T##options: CFDictionary?##CFDictionary?#>)
//        CGImageDestinationAddImageFromSource(dest, source, 0, NSDictionary.dictionaryWithObjectsAndKeys(exifDictkCGImagePropertyExifDictionarynil))   //エラー2
//        CGImageDestinationFinalize(dest)
//        var exportPath: String = "\(NSBundle.mainBundle().resourcePath)/export.jpg"
//        NSLog("exportPath : %@", exportPath)
//        imageData.writeToFile(exportPath, atomically: true)
//        CFRelease(cgImage)    //エラー3
//        CFRelease(dest)    //エラー3

        
        
//        metadata = editingInfo!
//        exifDatagettingMethod(image)
        performSegueWithIdentifier("uploadToEditingSegue", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
 */
        
        
//        photos framework
       
        let referenceURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let cfurl = CFBridgingRetain(referenceURL) as! CFURLRef
//        myImageSource = CGImageSourceCreateWithURL(cfurl, nil)
//        photoToEdit = info[UIImagePickerControllerOriginalImage] as? UIImage
//        let photo2 = info[UIImagePickerControllerEditedImage] as? UIImage
//        print("uploaded original size: \(photoToEdit?.size.width)")
//        print("EditedImage original size: \(photo2?.size.width)")
        
        let result = PHAsset.fetchAssetsWithALAssetURLs([referenceURL], options: nil)
         asset = result.firstObject as? PHAsset
//                let newAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
        
        
   

        
        self.metadata(referenceURL)
        performSegueWithIdentifier("uploadToEditingSegue", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
        func metadata(url: NSURL) {
            let asset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).firstObject as! PHAsset
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
        if (segue.identifier == "uploadToEditingSegue"){
            let toEditing = segue.destinationViewController as! EditingViewController
            toEditing.dict = dict
            toEditing.asset = asset
        }
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

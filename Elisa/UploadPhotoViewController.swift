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
    var photoToEdit: UIImage?
    var dict: [NSObject : AnyObject]?
    var myImageSource: CGImageSource?
    
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
        myImageSource = CGImageSourceCreateWithURL(cfurl, nil)
        photoToEdit = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.metadata(referenceURL)
        performSegueWithIdentifier("uploadToEditingSegue", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
//        let result = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil)
//        let asset = result.firstObject as! PHAsset
//        let newAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
//        
//       
//        let manager = PHImageManager.defaultManager()
//        manager.requestImageForAsset(asset, targetSize: CGSizeMake(100, 100), contentMode: .AspectFit , options: nil) { (UIImage, info: [NSObject : AnyObject]?) in
//            print("result")
//        }
 
        
     
    }
    
    func metadata(url: NSURL) {
        let asset = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil).firstObject as! PHAsset
            // get photo info from this asset
        let imageRequestOptions: PHImageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.synchronous = true
        let manager = PHImageManager.defaultManager()
        
        manager.requestImageDataForAsset(asset, options: imageRequestOptions) {(imageData, dataUTI, orientation, info) -> Void in
            self.dict = self.metadataFromImageData(imageData!)!
        }
       
        /*
        let url = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, UnsafePointer<UInt8>(), <#T##CFIndex#>, false)
            
            NSURL(string: "http://jwphotographic.co.uk/Images/1.jpg")
        CGImageSourceCreateWithURL(<#T##url: CFURL##CFURL#>, <#T##options: CFDictionary?##CFDictionary?#>)
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary
        
        println(imageProperties)
        */
        
        
        /*
        var imgPath: String = "\(NSBundle.mainBundle().resourcePath)/sample.jpg"
        var cgImage: CGImageSourceRef = CGImageSourceCreateWithURL(NSURL.fileURLWithPath(imgPath), nil)!
        var exifDict = NSMutableDictionary()
        exifDict.setObject("テストabc123", forKey: kCGImagePropertyExifUserComment)   //エラー1
        var imageData: NSMutableData = NSMutableData()
        var dest: CGImageDestinationRef = CGImageDestinationCreateWithData(imageData, CGImageSourceGetType(cgImage)!, 1, nil)!
        CGImageDestinationAddImageFromSource(dest, cgImage, 0, NSDictionary.dictionaryWithObjectsAndKeys(exifDictkCGImagePropertyExifDictionarynil))   //エラー2
        CGImageDestinationFinalize(dest)
        var exportPath: String = "\(NSBundle.mainBundle().resourcePath)/export.jpg"
        NSLog("exportPath : %@", exportPath)
        imageData.writeToFile(exportPath, atomically: true)
        CFRelease(cgImage)    //エラー3
        CFRelease(dest)    //エラー3
        */
        
        /*
        let imageData = UIImagePNGRepresentation(image)
        let coreImageData = CFDataCreate(kCFAllocatorDefault, imageData!.bytes.advancedBy(0), imageData?.length)
        let source = CGImageSourceCreateWithData(coreImageData, NULL)
        
//        let imageSource = CGImageSourceCreateWithData(imageData as! CFDataRef, nil)
        
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary;
        
        let exifDict = imageProperties.valueForKey("{Exif}")  as! NSDictionary;
        let dateTimeOriginal = exifDict.valueForKey("DateTimeOriginal") as! NSString;
        print ("DateTimeOriginal: \(dateTimeOriginal)");
        
        let lensMake = exifDict.valueForKey("LensMake");
        print ("LensMake: \(lensMake)");
    
        this is an example
        let aperture = imageProperties[kCGImagePropertyGPSLatitude] as! NSNumber!
 
 */
        
        /*
         these are all being defined as nil
         Load the ones from the exif data of the file
         let lensUsed = imageProperties[kCGImagePropertyExifFocalLength]
         let aperture = imageProperties[kCGImagePropertyExifApertureValue] as!
         let isoSpeed = imageProperties[kCGImagePropertyExifISOSpeedRatings] as! NSNumber
         let latitude = imageProperties[kCGImagePropertyGPSLatitude] as! NSNumber
         let longitude = imageProperties[kCGImagePropertyGPSLongitude] as! NSNumber
         let shutterSpeed = imageProperties[kCGImagePropertyExifShutterSpeedValue] as! NSNumber
         let cameraName = imageProperties[kCGImagePropertyExifBodySerialNumber] as! NSNumber
         */
    }
    
    /*
 
 
     
             if (imageProperties) {
                 NSDictionary *metadata = (__bridge NSDictionary *)imageProperties;
                 CFRelease(imageProperties);
                 CFRelease(imageSource);
                 NSLog(@"Metadata of selected image%@",metadata);// It will display the metadata of image after converting NSData into NSDictionary
                 return metadata;
                 
             }
             CFRelease(imageSource);
     

     
     */
    
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
            toEditing.photoToEdit = photoToEdit
            toEditing.dict = dict
            toEditing.myImageSource = myImageSource
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

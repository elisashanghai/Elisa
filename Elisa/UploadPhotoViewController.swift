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

class UploadPhotoViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    
    let initialImage = UIImage(named: "initial image")
    var photoToEdit: UIImage?
    var metadata: [String : AnyObject]?
    
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

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        photoToEdit = image
        metadata = editingInfo!
//        exifDatagettingMethod(image)
        performSegueWithIdentifier("uploadToEditingSegue", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
//        newPhoto = false

        
    }
//    
//    func exifDatagettingMethod (image: UIImage){
//     
////        let url = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, UnsafePointer<UInt8>(), <#T##CFIndex#>, false)
////            
////            NSURL(string: "http://jwphotographic.co.uk/Images/1.jpg")
////        CGImageSourceCreateWithURL(<#T##url: CFURL##CFURL#>, <#T##options: CFDictionary?##CFDictionary?#>)
////        let imageSource = CGImageSourceCreateWithURL(url, nil)
////        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary
//        
////        println(imageProperties)
//        
//        let imageData = UIImagePNGRepresentation(image)
//        let coreImageData = CFDataCreate(kCFAllocatorDefault, imageData!.bytes.advancedBy(0), imageData?.length)
//        let source = CGImageSourceCreateWithData(coreImageData, NULL)
//        
////        let imageSource = CGImageSourceCreateWithData(imageData as! CFDataRef, nil)
//        
//        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary;
//        
//        let exifDict = imageProperties.valueForKey("{Exif}")  as! NSDictionary;
//        let dateTimeOriginal = exifDict.valueForKey("DateTimeOriginal") as! NSString;
//        print ("DateTimeOriginal: \(dateTimeOriginal)");
//        
//        let lensMake = exifDict.valueForKey("LensMake");
//        print ("LensMake: \(lensMake)");
    
        //this is an example
//        let aperture = imageProperties[kCGImagePropertyGPSLatitude] as! NSNumber!
        
        /*
         //these are all being defined as nil
         //Load the ones from the exif data of the file
         let lensUsed = imageProperties[kCGImagePropertyExifFocalLength]
         let aperture = imageProperties[kCGImagePropertyExifApertureValue] as!
         let isoSpeed = imageProperties[kCGImagePropertyExifISOSpeedRatings] as! NSNumber
         let latitude = imageProperties[kCGImagePropertyGPSLatitude] as! NSNumber
         let longitude = imageProperties[kCGImagePropertyGPSLongitude] as! NSNumber
         let shutterSpeed = imageProperties[kCGImagePropertyExifShutterSpeedValue] as! NSNumber
         let cameraName = imageProperties[kCGImagePropertyExifBodySerialNumber] as! NSNumber
         */
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "uploadToEditingSegue"){
            let toEditing = segue.destinationViewController as! EditingViewController
            toEditing.photoToEdit = photoToEdit
            toEditing.metadata = metadata
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

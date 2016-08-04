//
//  ViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    var newPhoto: Bool = true
    var photoToEdit: UIImage?
    var previewToEdit: UIImage?
    var metadata: [String : AnyObject]?
    let initialImage = UIImage(named: "initial image")
    let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    let myFilters = Filters()
    var mySelectedFilter: Filter? = nil
    var editPreviewImage: UIImage?
    
    
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySelectedFilter = myFilters.filters[2]
        print(mySelectedFilter?.filterType)
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(initialPhotoTapped))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(photoEditTapped))
        photoPreviewImageView.userInteractionEnabled = true
        if newPhoto == true {
            photoPreviewImageView.image = initialImage
            photoPreviewImageView.addGestureRecognizer(tapGestureRecognizer)
            photoCollectionView.addGestureRecognizer(tapGestureRecognizer2)
            photoCollectionView.hidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func photoEditTapped(){
        
        editPreviewImage = mySelectedFilter?.applyFilter(previewToEdit!, filterType: (mySelectedFilter?.filterType)!)
        photoPreviewImageView.image = editPreviewImage
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        photoToEdit = image
        metadata = editingInfo!
        
        previewToEdit = imageScaling(photoToEdit!, scaledToWidth: myScreenSize.width)
        photoPreviewImageView.image = previewToEdit
        self.dismissViewControllerAnimated(true, completion: nil)
        photoCollectionView.hidden = false
        newPhoto = false
    }
   
   
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func imageScaling(sourceImage: UIImage, scaledToWidth i_width: CGFloat) -> UIImage {
        let oldWidth: CGFloat = sourceImage.size.width
        let scaleFactor: CGFloat = i_width / oldWidth
        let newHeight: CGFloat = sourceImage.size.height * scaleFactor
        let newWidth: CGFloat = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        sourceImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

}


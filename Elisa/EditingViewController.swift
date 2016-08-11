//
//  ViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import MobileCoreServices
import ImageIO

class EditingViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate
{
    
    var newPhoto: Bool = true
    var photoToEdit: UIImage?
    var previewToEdit: UIImage?
    var dict: [NSObject : AnyObject]?
    let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    let myFilters = Filters()
    var mySelectedFilter: Filter? = nil
    var editPreviewImage: UIImage?
    let numberOfItemsPerRow: CGFloat = 3.0
    var collectionViewLayout: CustomImageFlowLayout!
    var leftPreview: UIImage?
    var middlePreview: UIImage?
    var rightPreview: UIImage?
    var filterImage: UIImage?
    var filteredPreview: UIImage?
    var myImageSource: CGImageSource?
    
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        photoToEdit = UIImage(named: "example")
        previewToEdit = imageScaling(photoToEdit!, scaledToWidth: myScreenSize.width)
        photoPreviewImageView.image = previewToEdit
        collectionViewLayout = CustomImageFlowLayout()
        photoCollectionView.collectionViewLayout = collectionViewLayout
        leftPreview = previewToEdit?.leftPart
        middlePreview = previewToEdit?.middlePart
        rightPreview = previewToEdit?.rightPart
        let width = myScreenSize.width / numberOfItemsPerRow
        let layout = collectionViewLayout as UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoEditTapped))
        photoPreviewImageView.userInteractionEnabled = true
        
        photoPreviewImageView.addGestureRecognizer(tapGestureRecognizer)
        photoCollectionView.allowsMultipleSelection = false
       

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func photoEditTapped(){
        
        photoPreviewImageView.image = previewToEdit
        mySelectedFilter = nil
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
    
    //Mark: -Collection View Settings
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(myFilters.filters.count)
        return myFilters.filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FilterCollectionViewCell
        if (indexPath.row + 1) % 3 == 0 {
            filterImage = myFilters.filters[indexPath.row].applyFilter(rightPreview!, filterType: myFilters.filters[indexPath.row].filterType)
        }
        else if (indexPath.row + 1) % 2 == 0 {
            filterImage = myFilters.filters[indexPath.row].applyFilter(middlePreview!, filterType: myFilters.filters[indexPath.row].filterType)
        }
        else {
            filterImage = myFilters.filters[indexPath.row].applyFilter(leftPreview!, filterType: myFilters.filters[indexPath.row].filterType)
        }
        
        
        cell.filterImageView.image = filterImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        mySelectedFilter = myFilters.filters[indexPath.row]
        filteredPreview = mySelectedFilter?.applyFilter(previewToEdit!, filterType: mySelectedFilter!.filterType)
        photoPreviewImageView.image = filteredPreview
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editingToSharingSegue"){
            let toSharing = segue.destinationViewController as! SharingViewController
            toSharing.photoToEdit = photoToEdit
            toSharing.dict = dict
            toSharing.mySelectedFilter = mySelectedFilter
            toSharing.myImageSource = myImageSource
        }
    }


}

extension UIImage {
//    var topHalf: UIImage? {
//        guard let image = CGImageCreateWithImageInRect(CGImage,
//                                                       CGRect(origin: CGPoint(x: 0, y: 0),
//                                                        size: CGSize(width: size.width, height: size.height/2)))
//            else { return nil }
//        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
//    }
//    
//    var bottomHalf: UIImage? {
//        guard let image = CGImageCreateWithImageInRect(CGImage,
//                                                       CGRect(origin: CGPoint(x: 0,  y: CGFloat(Int(size.height)-Int(size.height/2))),
//                                                        size: CGSize(width: size.width, height: CGFloat(Int(size.height) - Int(size.height/2)))))
//            else { return nil }
//        return UIImage(CGImage:
//            image, scale: 1, orientation: imageOrientation)
//    }
    var leftPart: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
                                                       CGRect(origin: CGPoint(x: 0, y: 0),
                                                        size: CGSize(width: size.width/3, height: size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
    }
    
    var middlePart: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
                                                       CGRect(origin: CGPoint(x: CGFloat(size.width/3), y: 0),
                                                        size: CGSize(width: size.width/3, height: size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
        
    }
    var rightPart: UIImage? {
        guard let image = CGImageCreateWithImageInRect(CGImage,
                                                       CGRect(origin: CGPoint(x: CGFloat(Int(size.width)-Int((size.width/3))), y: 0),
                                                         size: CGSize(width: size.width/3, height: size.height)))
            else { return nil }
        return UIImage(CGImage: image, scale: 1, orientation: imageOrientation)
    }
}


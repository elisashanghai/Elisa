//
//  PhotoPreviewViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import Photos
import ImageIO

class PhotoViewController: UIViewController,UIScrollViewDelegate {
    
    
    var filteredPhoto: UIImage?
    var bigImageView = UIImageView()
    let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    var mySelectedFilter = Filter?()
    var asset: PHAsset?
    var isLoaded: Bool = false
    var filteredPreview: UIImage?

    
 
    @IBOutlet weak var scrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
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

            
            
            let photoToEdit = getAssetFullImage(self.asset!)
            
            if self.mySelectedFilter == nil {
                self.filteredPhoto = photoToEdit
            }
            else {
                self.filteredPhoto = self.mySelectedFilter!.applyFilter(photoToEdit, filterType: self.mySelectedFilter!.filterType)}
            print("filteredPhoto size: \(self.filteredPhoto?.size.width)")
            self.isLoaded = true
            
                self.bigImageView.image = self.filteredPhoto
            
            
        }
        
        
            bigImageView.image = filteredPhoto
            bigImageView.frame.size.height = (myScreenSize.width)
            bigImageView.frame.size.width = (myScreenSize.width)/(filteredPhoto?.size.height)!*(filteredPhoto?.size.width)!
        
        
        bigImageView.frame.origin.x = 0
        bigImageView.frame.origin.y = 0
        
        scrollView.maximumZoomScale = 6.0
        scrollView.minimumZoomScale = 1.0
        
        scrollView.addSubview(bigImageView)
        self.scrollView.contentSize = bigImageView.frame.size
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapped))
        bigImageView.userInteractionEnabled = true
        bigImageView.addGestureRecognizer(tapGestureRecognizer)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.bigImageView
    }
    func photoTapped(){
        dismissViewControllerAnimated(true, completion: nil)
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

//
//  PhotoPreviewViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UIScrollViewDelegate {
    
    
    var filteredPhoto: UIImage?
    var bigImageView = UIImageView()
     let myScreenSize: CGRect = UIScreen.mainScreen().bounds
    
 
    @IBOutlet weak var scrollView: UIScrollView!

   
    @IBAction func dismissSegueInPhotoView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

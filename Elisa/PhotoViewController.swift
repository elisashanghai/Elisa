//
//  PhotoPreviewViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var filteredPhoto: UIImage?

    @IBOutlet weak var bigImageView: UIImageView!
    
    @IBAction func dismissSegueInPhotoView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bigImageView.image = filteredPhoto

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

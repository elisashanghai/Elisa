//
//  SharingViewController.swift
//  Elisa
//
//  Created by Yang Song on 8/3/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit
import Social

class SharingViewController: UIViewController {
    var mySelectedFilter = Filter(filterType: FilterType.Hue)
    var photoToEdit = UIImage(named: "golden gate")
    var metadata: [String : AnyObject]?
    var filteredPhoto: UIImage?

    @IBOutlet weak var filteredPhotoImageView: UIImageView!
    @IBAction func buttonFacebookTapped(sender: AnyObject) {
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        composeSheet.setInitialText("Hello, Facebook!")
        composeSheet.addImage(filteredPhoto)
        
        presentViewController(composeSheet, animated: true, completion: nil)
    }
    
    @IBAction func buttonTwitterTapped(sender: AnyObject) {
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        composeSheet.setInitialText("Hello, Twitter!")
        composeSheet.addImage(filteredPhoto)
        
        presentViewController(composeSheet, animated: true, completion: nil)

    }
    
    @IBAction func buttonCameraRollTapped(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(filteredPhoto!, nil, nil, nil)
    }

    
    @IBAction func dismissSegueInSharingView(sender: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filteredPhoto = mySelectedFilter.applyFilter(photoToEdit!, filterType: mySelectedFilter.filterType)
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

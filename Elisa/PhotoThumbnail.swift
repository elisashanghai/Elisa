//
//  PhotoThumbnail.swift
//  Elisa
//
//  Created by Yang Song on 8/19/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setThumbnailImage(thumbnailImage:UIImage){
        self.imageView?.image = thumbnailImage
    }
}

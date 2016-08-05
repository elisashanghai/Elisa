//
//  filterCollectionViewCell.swift
//  Filter360
//
//  Created by Yang Song on 7/31/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit


class  FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        filterImageView.image = nil
    }

    
}


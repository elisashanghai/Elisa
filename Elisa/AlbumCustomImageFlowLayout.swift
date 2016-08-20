//
//  AlbumCustomImageFlowLayout.swift
//  Elisa
//
//  Created by Yang Song on 8/19/16.
//  Copyright © 2016 Yang Song. All rights reserved.
//

import UIKit

class AlbumCustomImageFlowLayout: UICollectionViewFlowLayout {
    
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 1
            let itemWidth = (CGRectGetWidth(self.collectionView!.frame) - (numberOfColumns - 1)) / numberOfColumns
            return CGSizeMake(itemWidth, 100.0)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .Vertical
    }
    
}

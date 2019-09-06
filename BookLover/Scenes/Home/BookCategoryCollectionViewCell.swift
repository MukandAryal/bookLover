//
//  BookCategoryCollectionViewCell.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class BookCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblName: UILabelFontSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
}

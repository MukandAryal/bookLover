//
//  CategaryCollectionViewCell.swift
//  BookLover
//
//  Created by Mss Mukunda on 18/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class CategaryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCategaryName: UILabelFontSize!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }

}

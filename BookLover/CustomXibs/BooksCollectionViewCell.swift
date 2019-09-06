//
//  BooksCollectionViewCell.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit
import Cosmos

class BooksCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgBookCover: UIImageView!
    
    @IBOutlet weak var btnFavUnfav: UIButton!
    
    @IBOutlet weak var btnReviews: UIButtonFontSize!
    
    @IBOutlet weak var lblBookName: UILabelFontSize!
    
    @IBOutlet weak var lblAuthorName: UILabelFontSize!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var btnBookSelf: UIButton!
    
    var homeInteractor: HomeBusinessLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingView.settings.fillMode = .full
        btnReviews.layer.cornerRadius = 3.0
        imgBookCover.layer.cornerRadius = 6.0
        imgBookCover.clipsToBounds = true
    }
    
}

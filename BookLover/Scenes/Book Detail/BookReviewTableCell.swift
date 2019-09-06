//
//  BookReviewTableCell.swift
//  BookLover
//
//  Created by ios 7 on 29/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit
import Cosmos

class BookReviewTableCell: UITableViewCell {

    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabelFontSize!
    @IBOutlet weak var reviewDateLbl: UILabelFontSize!
    @IBOutlet weak var reviewDescriptionLbl: UILabelFontSize!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var likeBtn: UIButtonFontSize!
    @IBOutlet weak var commentBtn: UIButtonFontSize!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageBtn.layer.cornerRadius = profileImageBtn.frame.size.height/2.0
        profileImageBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

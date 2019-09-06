//
//  FilterTableViewCell.swift
//  BookLover
//
//  Created by Mss Mukunda on 06/06/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAge: UILabelFontSize!
    @IBOutlet weak var imgCheckBox: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

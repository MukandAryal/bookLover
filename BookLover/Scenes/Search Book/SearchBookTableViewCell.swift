//
//  SearchBookTableViewCell.swift
//  BookLover
//
//  Created by Mss Mukunda on 22/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var booknameLbl: UILabelFontSize!
    @IBOutlet weak var authornameLbl: UILabelFontSize!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

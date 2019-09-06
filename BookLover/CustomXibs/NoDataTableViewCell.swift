//
//  NoDataTableViewCell.swift
//  BookLover
//
//  Created by ios 7 on 24/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblNoData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

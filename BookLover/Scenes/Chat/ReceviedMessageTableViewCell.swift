//
//  ReceviedMessageTableViewCell.swift
//  WebSocket
//
//  Created by Mss Mukunda on 25/06/18.
//  Copyright © 2018 Mss Mukunda. All rights reserved.
//

import UIKit

class ReceviedMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblReceviedMessage: UILabel!
    @IBOutlet weak var lblReceviedMessageTym: UILabel!
    @IBOutlet weak var viewReceviedMesssage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewReceviedMesssage.layer.cornerRadius = 10
        viewReceviedMesssage.clipsToBounds = true

        // Configure the view for the selected state
    }

}

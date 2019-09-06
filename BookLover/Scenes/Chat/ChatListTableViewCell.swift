//
//  ChatListTableViewCell.swift
//  BookLover
//
//  Created by Mss Mukunda on 25/06/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var lblUserName: UILabelFontSize!
    @IBOutlet weak var lblLastMessage: UILabelFontSize!
    @IBOutlet weak var lblMessageTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnProfilePic.layer.cornerRadius = btnProfilePic.frame.size.height/2.0
        btnProfilePic.layer.borderWidth = 1.0
        btnProfilePic.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

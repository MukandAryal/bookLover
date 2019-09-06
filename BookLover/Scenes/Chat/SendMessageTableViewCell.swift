//
//  SendMessageTableViewCell.swift
//  WebSocket
//
//  Created by Mss Mukunda on 25/06/18.
//  Copyright © 2018 Mss Mukunda. All rights reserved.
//

import UIKit

class SendMessageTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSendMessage: UILabel!
    @IBOutlet weak var lblSendMessageTym: UILabel!
    @IBOutlet weak var viewSendMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewSendMessage.layer.cornerRadius = 10
        viewSendMessage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

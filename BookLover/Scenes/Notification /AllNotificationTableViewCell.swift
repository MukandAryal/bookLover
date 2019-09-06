//
//  AllNotificationTableViewCell.swift
//  BookLover
//
//  Created by Mss Mukunda on 17/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class AllNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationCollectionView: UICollectionView!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var notificationLbl: UILabelFontSize!
    @IBOutlet weak var notificatioTimeLbl: UILabelFontSize!
    @IBOutlet weak var acceptBtn: UIButton?
    @IBOutlet weak var declineBtn: UIButton?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileBtn.layer.cornerRadius = userProfileBtn.frame.size.height/2.0
        userProfileBtn.layer.borderWidth = 1.0
        userProfileBtn.clipsToBounds = true
        
        acceptBtn?.layer.cornerRadius = ((acceptBtn?.frame.size.height))!/2.0
        acceptBtn?.clipsToBounds = true
        
        declineBtn?.layer.cornerRadius = ((declineBtn?.frame.size.height))!/2.0
        declineBtn?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}



//
//  AllNotificationRequestTableViewCell.swift
//  BookLover
//
//  Created by Nitesh Chauhan on 6/7/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class AllNotificationRequestTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabelFontSize!
    @IBOutlet weak var userAgeLabel: UILabelFontSize!
    @IBOutlet weak var userLocationLabel: UILabelFontSize!
    @IBOutlet weak var acceptBtn: UIButton?
    @IBOutlet weak var declineBtn: UIButton?
    var arrCategory : [String]?
    var vcObj : AllNotificationViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        acceptBtn?.layer.cornerRadius = ((acceptBtn?.frame.size.height))!/2.0
        acceptBtn?.clipsToBounds = true
        
        declineBtn?.layer.cornerRadius = ((declineBtn?.frame.size.height))!/2.0
        declineBtn?.clipsToBounds = true
        
        userProfileBtn?.layer.cornerRadius = ((userProfileBtn?.frame.size.height))!/2.0
        userProfileBtn?.clipsToBounds = true
        
        notificationCollectionView.register(UINib(nibName: ViewControllerIds.CategaryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.CategaryCellIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension AllNotificationRequestTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var strText : String!
        strText = "\((arrCategory?[indexPath.item]))"
        
        let dynamicWidth =  strText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont(name: "Futura", size: 12)!], context: nil).size.width
        
        return CGSize(width: dynamicWidth+10, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrCategory?.count)!
        //return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.CategaryCellIdentifier, for: indexPath) as! CategaryCollectionViewCell
        
        cell.lblCategaryName.text = arrCategory?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}


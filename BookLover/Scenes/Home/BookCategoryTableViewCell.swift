//
//  BookCategoryTableViewCell.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit

class BookCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookCategoryCollectionView: UICollectionView!
    var arrCategory : [Home.ViewModel.Categories]?
    var vcObj : HomeViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookCategoryCollectionView.register(UINib(nibName: ViewControllerIds.CategaryCellIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.CategaryCellIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension BookCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var strText : String!
        if arrCategory!.count > 0 {
            strText = " \((arrCategory![indexPath.item].name!)) "
        } else {
            strText = localizedTextFor(key: HomeSceneText.Category.rawValue) + " \(indexPath.item) "
        }

        let dynamicWidth =  strText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont(name: "Futura-Medium", size: 20)!], context: nil).size.width
        
        return CGSize(width: dynamicWidth+5, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if  arrCategory!.count > 0 {
            return arrCategory!.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.CategaryCellIdentifier, for: indexPath) as! CategaryCollectionViewCell
        cell.layer.cornerRadius = 0.0
        cell.backgroundColor = UIColor.clear
        cell.lblCategaryName.layer.cornerRadius = 5.0
        cell.lblCategaryName.textColor = appThemeColor
        cell.lblCategaryName.clipsToBounds = true
        cell.lblCategaryName.backgroundColor = UIColor(red: 83.0/256, green: 83.0/256, blue: 83.0/256, alpha: 1.0)
        if  arrCategory!.count > 0 {
            let data = arrCategory![indexPath.item]
            cell.lblCategaryName.text = data.name
        } else {
            cell.lblCategaryName.text = localizedTextFor(key: HomeSceneText.Category.rawValue) + " \(indexPath.item) "
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vcObj?.router?.navigateToAllBooks(withTitle: (arrCategory![indexPath.row].name)!, andCatId: "\((arrCategory![indexPath.row].id)!)", orderNo: nil)
    }
}

//
//  ShowPopoverViewController.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 14/02/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit
import Alamofire

extension UIViewController: UIPopoverPresentationControllerDelegate
    
{
   
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popToEditDeleteReview(onButton: UIButton, withData: [String:Any]?, completionMethod: @escaping DeleteReviewCompletion) {
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIds.EditDeleteReview) as! EditDeleteReviewPopUp
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        //        popController.popoverPresentationController?.barButtonItem = onBarButtonItem
        popController.popoverPresentationController?.sourceView = onButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: onButton.bounds.midX, y: onButton.bounds.maxY, width: 0, height: 0)
        popController.preferredContentSize = CGSize(width: 150, height: 100)
        popController.nav = self.navigationController
        popController.dictData = withData
        popController.callbackDismiss = completionMethod
        self.present(popController, animated: true) {
            popController.view.superview?.layer.cornerRadius = 0
        }
    }
    
    func popToBlockPopUp(onButton: UIButton,  withFriendId: String?, isBocked: Bool, atCompletion: @escaping BlockUserCompletion) {
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewControllerIds.BlockPopUp) as! BlockPopUp
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = onButton
        popController.popoverPresentationController?.sourceRect = CGRect(x: onButton.bounds.midX, y: onButton.bounds.maxY, width: 0, height: 0)
        let height = isBocked ? 100 :100
        popController.preferredContentSize = CGSize(width: 150, height: height)
        popController.nav = self.navigationController
        popController.friendId = withFriendId
        popController.isBlock = isBocked
        popController.callPopUpDismiss = atCompletion
        self.present(popController, animated: true) {
            popController.view.superview?.layer.cornerRadius = 0
        }
    }
}

//
//  CustomNavigationItems.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/03/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import Foundation
import UIKit

/// This class is made to custmize UINavigation bar with navigation title and left bar button items.

class CustomNavigationItems {
    
    var currentVC: UIViewController?
    let navButtonFrame = CGRect(x: 0, y: 0, width: 35, height: 35)
    static let sharedInstance = CustomNavigationItems()
    
    /**
     This function is made for custimizing navigation title.
     
 
    static func customTitleViewOnNavigationBar(onViewController: UIViewController, withNavigationTitle: String, withTextAlignment: NSTextAlignment)
    {
        let navLabel = UILabel(frame: CGRect(x: (onViewController.view.frame.width - 220)/2, y: 0, width: 220, height: 40))
        navLabel.attributedText = NSMutableAttributedString(string: valueProvider(fromKey: withNavigationTitle), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)])
        navLabel.numberOfLines = 0
        //navLabel.btnProfilegroundColor = UIColor.brown
        navLabel.textAlignment = withTextAlignment
        navLabel.textColor = UIColor.black
        onViewController.navigationItem.titleView = navLabel
    }
   */
    
    /**
     This function is made to add left bar button items with same functionality(including appearence as well as actions) you don't have to add left barbutton items from storyboard or even from code if you want to use below nar button items. you only have to add this function. 
     
     ### Usage Example: ###
     ````
     
     CustomNavigationItems.sharedInstance.leftBarButtonItems(onViewController: yourViewcontroller)
     
     ````
     */
    
   // func leftBarButtonItems(onViewController: UIViewController)
//    {
//        self.currentVC = onViewController
//
//
//
//        let btnProfile = UIButton(type: .system)
//        btnProfile.setImage(UIImage(named: "btnProfileIcon"), for: .normal)
//        btnProfile.addTarget(self, action: #selector(profileBarButtonItemClicked(sender:)), for: .touchUpInside)
//        btnProfile.imageEdgeInsets = LeftButtonImageInsets
//        btnProfile.frame = navButtonFrame
//        btnProfile.tintColor = UIColor.black
//        let btnProfileBtn = UIBarButtonItem(customView: btnProfile)
//
//        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//
//        fixedSpace.width = 1
//
//        let btnSearch = UIButton(type: .system)
//        btnSearch.setImage(UIImage(named: "AppCartIcon"), for: UIControlState())
//        btnSearch.tintColor = ThemeColor
//        btnSearch.imageEdgeInsets = LeftButtonImageInsets
//        btnSearch.frame = navButtonFrame
//        btnSearch.addTarget(self, action: #selector(homeButtonItemClicked(sender:)), for: UIControlEvents.touchUpInside)
//        let home = UIBarButtonItem(customView: btnSearch)
//        onViewController.navigationItem.setLeftBarButtonItems([fixedSpace,btnProfileBtn,fixedSpace,home,fixedSpace], animated: false)
//    }
    
    func setNavigationBarApperrance(onVC: UIViewController, withTitle: String?) {
    
        onVC.navigationItem.title = withTitle
        onVC.navigationItem.setHidesBackButton(true, animated:true);
        onVC.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       // onVC.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        onVC.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : appThemeColor]
        
        if #available(iOS 11.0, *) {
            onVC.navigationController?.navigationBar.prefersLargeTitles = true
            onVC.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: appThemeColor]
        }
        
        
        // For transparent color of navigation bar
        onVC.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        onVC.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    func rightBarButton(onVC: UIViewController) {
        
        self.currentVC = onVC
        
        let btnNotification = UIButton(type: .system)
        btnNotification.frame = navButtonFrame
        btnNotification.setImage(UIImage(named: "bell"), for: UIControlState())
        btnNotification.tintColor = UIColor.white
        btnNotification.addTarget(self, action: #selector(notificationButtonItemClicked(sender:)), for: UIControlEvents.touchUpInside)
        let notification = UIBarButtonItem(customView: btnNotification)
        if let cc = userDefault.value(forKey: userDefualtKeys.notificationCount.rawValue) as? Int {
            
            if cc == 0
            {
                notification.removeBadge()
            }else {
                
                notification.addBadge(number: Int(cc), withOffset: .zero, andColor: appThemeColor, andFilled: true)
            }
        }
        
        if !((self.currentVC?.isKind(of: HomeViewController.self))!) {
            
       // onVC.navigationItem.setRightBarButtonItems([notification], animated: false)
            return
        }
        
        let btnSearch = UIButton(type: .system)
        btnSearch.frame = navButtonFrame
        btnSearch.setImage(UIImage(named: "serch"), for: UIControlState())
        btnSearch.tintColor = UIColor.white
        btnSearch.addTarget(self, action: #selector(searchButtonItemClicked(sender:)), for: UIControlEvents.touchUpInside)
        let search = UIBarButtonItem(customView: btnSearch)
        
        let btnProfile = UIButton(type: .system)
        btnProfile.frame = navButtonFrame
        btnProfile.setImage(UIImage(named: "my_profile"), for: .normal)
        btnProfile.addTarget(self, action: #selector(profileButtonItemClicked(sender:)), for: .touchUpInside)
//        btnProfile.imageEdgeInsets = LeftButtonImageInsets
//        btnProfile.frame = navButtonFrame
        btnProfile.tintColor = UIColor.white
        let profile = UIBarButtonItem(customView: btnProfile)
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            onVC.navigationItem.setRightBarButtonItems([profile, notification,search], animated: false)
        }else{
            onVC.navigationItem.setRightBarButtonItems([profile,search], animated: false)
        }
        
       // onVC.navigationItem.setRightBarButtonItems([profile,search], animated: false)
        
        //onVC.navigationItem.setRightBarButtonItems([notification,profile,search], animated: false)
    }
    
    
    func leftBarButton(onVC: UIViewController) {
        
        self.currentVC = onVC
        
        let btnBack = UIButton(type: .system)
        btnBack.frame = navButtonFrame
        btnBack.setImage(UIImage(named: "back"), for: UIControlState())
        btnBack.tintColor = UIColor.white
        btnBack.addTarget(self, action: #selector(backButtonItemClicked(sender:)), for: UIControlEvents.touchUpInside)
        let Back = UIBarButtonItem(customView: btnBack)

        onVC.navigationItem.setLeftBarButtonItems([Back], animated: false)
    }
    
    /**
     This function contains the action for left btnProfile button.
     
     */
    
    @objc func backButtonItemClicked(sender: UIButton)
    {
        self.currentVC?.view.endEditing(true)
        if (self.currentVC?.isKind(of: LoginViewController.self))! {
            self.homeButtonItemClicked(sender: nil)
        } else {
            self.currentVC?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func profileButtonItemClicked(sender: UIButton)
    {
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let vcObj = self.currentVC?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.UserProfile) as? ProfileViewController
            var ds = vcObj?.router?.dataStore
            passDataToProfile(withId: CommonFunctions.sharedInstance.getUserId(), destinationDS: &ds!)
            self.currentVC?.navigationController?.pushViewController(vcObj!, animated: true)
        } else {
            let vcObj = self.currentVC?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Login) as? LoginViewController
            self.currentVC?.navigationController?.pushViewController(vcObj!, animated: true)
        }
    }
    
    func passDataToProfile(withId: String, destinationDS: inout ProfileDataStore)
    {
        destinationDS.userId = withId
        destinationDS.isFromSideMenu = false
    }
    
    @objc func searchButtonItemClicked(sender: UIButton)
    {
            let vcObj = self.currentVC?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.SearchBook) as? SearchBookViewController
            self.currentVC?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    @objc func notificationButtonItemClicked(sender: UIButton)
    {
        //CustomAlertController.sharedInstance.showComingSoonAlert()
        //self.currentVC?.navigationController?.popViewController(animated: true)
        let vcObj = self.currentVC?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Notification) as? AllNotificationViewController
        self.currentVC?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    /**
     This function contains the action for left home button.
     
     */
    
    @objc func homeButtonItemClicked(sender: UIButton?)
    {
        for controller in (self.currentVC?.navigationController!.viewControllers)! {
            if controller.isKind(of: HomeViewController.self) {
                self.currentVC?.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
    }
}


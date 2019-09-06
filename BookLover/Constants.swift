//
//  Constants.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import Foundation
import UIKit


let appDelegateObj = UIApplication.shared.delegate as! AppDelegate

let userDefault = UserDefaults.standard

let asterik = NSAttributedString(string: "*", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])

let strikeThrough = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)]

let appThemeColor = UIColor(red: 242.0/256, green: 223.0/256, blue: 0.0/256, alpha: 1.0)
let appBackGroundColor = UIColor(red: 56.0/256, green: 56.0/256, blue: 56.0/256, alpha: 1.0)

let deviceType = "ios"
let cellReUseIdentifier = "Cell"
let ACCEPTABLE_NAMETEXT = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

let TotalWidth = UIScreen.main.bounds.size.width
let TotalHeight = UIScreen.main.bounds.size.height

let SuccessCode: NSNumber = 200
let FailureCode: NSNumber = 999
let maxAge:Int = 120
let minAge:Int = 8

// StoryBoard name

let mainStoryboard = "Main"
let settingStoryboard = "Setting"

let Error404:String = "Not Found"
//let TokenExpiryCode = 500

let FontName = "Futura-Medium"

enum userDefualtKeys:String {
    
    case user_Id = "loggedInUserId"
    case user_Token = "loggedInUserToken"
    case userLoggedIn = "isLoggedIn"
    case countryList = "countryList"
    case userObject = "UserInfo"
    case sideMenu = "SideMenu"
    case userProfileCompleted = "ProfileComplete"
    case userLat = "userLat"
    case userLong = "userLong"
    case notificationCount = "notificationCount"
}


enum DateFormats: String {
    /**
     "dd-MM-yyyy"
     */
    case format1 = "dd-MM-yyyy"
    
    /**
     "HH:MM:a"
     */
    case format2 = "HH:MM a"
    
    /**
     "dd/MM/yyyy"
     */
    case format3 = "dd/MM/yyyy"
    
    /**
     "dd-MMM"
     */
    case format4 = "dd-MMM"
    
    /**
     "mm-dd-yyyy  hh:mm a"
     */
    case format5 = "mm-dd-yyyy  hh:mm a"
    
    /**
     "dd MMM YYYY"
     */
    case format6 = "dd MMM YYYY"
    
    /**
     "yyyy-MM-dd HH:mm"
     */
    case format7 =  "yyyy-MM-dd HH:mm"
    
    /**
     "dd-MMM, hh:mm a"
     */
    
    case format8 =  "dd-MMM, hh:mm a"
    
    /**
     "hh:mm a"
     */
    
    case format9 =  "hh:mm a"
    
    /**
     "dd MMM YYYY  hh:mm a"
     */
    
    case format10 = "dd MMM YYYY  hh:mm a"
    
    
    // 2018-05-25T10:50:01+00:00
    case format11 = "yyyy-MM-dd"
    
}

enum AppStoryboard : String {
    case Main, Setting
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

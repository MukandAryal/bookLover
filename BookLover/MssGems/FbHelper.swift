//
//  FbHelper.swift
//  MagentoMobileShop
//
//  Created by ios 7 on 14/02/18.
//  Copyright © 2018 Coder. All rights reserved.
//

import UIKit
import FBSDKLoginKit
typealias fbHandler = ((_ response: String?, _ error:Error?)->(Void))


/// This is a Helper class for getting socialLogin(facebook) access.

class FbHelper: NSObject {

    /**
     
     This function is made for getting accesstoken from facebook.
     
     - Parameters:  dictionary, viewcontroller, completionblock
     
     */
    
    
    class func fb_LoginWith(arrPermision:[Any]?, vc:UIViewController, completion: @escaping fbHandler){
        
        let login = FBSDKLoginManager()
        login.logOut()
        login.logIn(withReadPermissions: ["public_profile", "email"], from: vc) { (loginResult:Any?, error:Error?) in
            
            if ((error) != nil){
                printToConsole(item:"-- Error in Login --")
                completion(nil, error)
            }else{
                let token = FBSDKAccessToken.current()
                guard let access_token = token?.tokenString else{return}
                printToConsole(item:"access_Token -- \(access_token)")
                completion(access_token, nil)
            }
        }
    }
}

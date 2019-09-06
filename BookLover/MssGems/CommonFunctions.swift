
import UIKit
import Alamofire


class CommonFunctions: NSObject {
    
    static let sharedInstance = CommonFunctions()
    
    private override init() {}
    
    /**
     Call this function to generate random number of preferred length.
     */
    
    func generateRandomNumber(length:Int) -> String {
        var place:UInt32 = 1
        var finalNumber:UInt32 = 0
        for _ in 0..<length-1 {
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += randomNumber * place
        }
        return "2018"
    }
    
    func getFontSizeFrom( _ height: CGFloat) -> CGFloat {
        var fontHeight : CGFloat = 14.0
        if TotalWidth == 414 {
            fontHeight = height
        } else if TotalWidth == 375 {
            fontHeight = height-1
        } else {
            fontHeight = height-2
        }
        return fontHeight
    }
    
    /**
    
    func updateUserData(_ attribute:userAttributes, value:String) {
       // UnArchiving user attributes object
        if let userData:Data = userDefault.value(forKey: userDefualtKeys.UserObject.rawValue) as? Data {
            if let userDict:NSMutableDictionary = NSKeyedUnarchiver.unarchiveObject(with: userData) as? NSMutableDictionary {

        userDict[attribute.rawValue] = value

                // saving again to userDefault
                let resultData = NSKeyedArchiver.archivedData(withRootObject: userDict)
                userDefault.set(resultData, forKey: userDefualtKeys.UserObject.rawValue)

                // updating app instance unarchived user object
                appDelegateObj.unarchiveUserData()
            }
        }
    }
  */
    
    func openGoogleMap(destinationLatitude:Double, destinationLongitude:Double) {
        let url = URL(string: "http://maps.google.com/?saddr=\(LocationWrapper.sharedInstance.latitude),\(LocationWrapper.sharedInstance.longitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")
        printToConsole(item: "Direction url \(String(describing: url))")
        if (UIApplication.shared.canOpenURL(url!)) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }
        else {
            printToConsole(item: "Can't open google maps")
        }
    }
    
    func hitFavouriteUnfavouriteApi(withData: [String:Any], apiResponse:@escaping(responseHandler)) {
        
        let headersArray = getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.likeDislike, httpMethod: .post, headers: headersArray, parameters: withData, encoding: nil) { (response) in
            apiResponse(response)
        }
    }

    
    func hitReviewLikeApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let header:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.reviewLikeDislike, httpMethod: .post, headers: header, parameters: parameters, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }

    
    func hitBookShelfApi(withData: [String:Any], apiResponse:@escaping(responseHandler)) {
        
        let headersArray = getHeaders()
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.shelfStatus, httpMethod: .post, headers: headersArray, parameters: withData, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    
    func showLoginAlert(referenceController:UIViewController) {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: GeneralText.pleaseLogin.rawValue), description: "", image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        }))

        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)

            // moving to login screen
            /**
            let storyBoard = AppStoryboard.Main.instance
            let initialNavigationController = storyBoard.instantiateViewController(withIdentifier: ViewControllersIds.InitialControllerID)
            appDelegateObj.window?.rootViewController = initialNavigationController
            appDelegateObj.window?.makeKeyAndVisible()
         */
        }))

        referenceController.present(alertController, animated: true, completion: nil)
    }
    
    
    func navigateLoginVC() {
        
        let vcObj = topViewController()
        var isFound : Bool = false
        for controller in (vcObj?.navigationController?.viewControllers)! {
            if controller.isKind(of: LoginViewController.self) {
                vcObj?.navigationController?.popToViewController(controller, animated: false)
                isFound = true
                break
            }
        }
        
        if isFound == false {
            
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let loginObj = storyBoard.instantiateViewController(withIdentifier: ViewControllerIds.Login) as? LoginViewController
            vcObj?.navigationController?.pushViewController(loginObj!, animated: true)
        }
    }
    
    
    func navigateToHome(nav: UINavigationController) {
        
        var isFound : Bool = false
        for controller in (nav.viewControllers) {
            if controller.isKind(of: HomeViewController.self) {
                nav.popToViewController(controller, animated: false)
                isFound = true
                break
            }
        }
        
        if isFound == false {
            let vcObj = topViewController()
            let homeObj = vcObj?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Home) as? HomeViewController
            vcObj?.navigationController?.pushViewController(homeObj!, animated: true)
        }
    }
    
    
    func json(from object:Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue)
    }
    
    func isSideMenuOpened() -> Bool {
        return userDefault.bool(forKey: userDefualtKeys.sideMenu.rawValue)
    }
    
    
    func isProfileCompleted() -> Bool {
        return userDefault.bool(forKey: userDefualtKeys.userProfileCompleted.rawValue)
    }
    
    func getUserId() -> String {
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        return "\(userId)"
    }
    
    func getHeaders() -> HTTPHeaders {
        //application/x-www-form-urlencoded
        var header:HTTPHeaders = ["Content-Type":"application/json"]
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true  {
            let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
            header.updateValue(token, forKey: "Authorization")
        }
        return header
    }
    
    func topViewController(controller: UIViewController? = (appDelegateObj.window?.rootViewController)!) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    func removeUserData() {
        
        userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
        userDefault.set(false, forKey: userDefualtKeys.userProfileCompleted.rawValue)
        
        // updating user data in user default
        userDefault.removeObject(forKey: userDefualtKeys.userObject.rawValue)
        
        // Clears app delegate user object dictioary
        appDelegateObj.userData.removeAllObjects()
    }
    
    
    func generateDateString(_ date: Date, format: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func generateDate(_ dateString: String, format: DateFormats) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func updateUserInfoPrivacy(_ name: String, withValue: Int) {
        
        let userData = appDelegateObj.userData
        var privacyArr = userData["Privacies"] as! [[String:Any]]
        var privacyData = privacyArr[0]
        privacyData.updateValue(withValue ,forKey:name)
        privacyArr[0] = privacyData
        userData["Privacies"] = privacyArr
        printToConsole(item: userData)
        appDelegateObj.userData = userData
    }
    
    func getUserInfoPrivacyData() -> [String:Any] {
        
        let userData = appDelegateObj.userData
        var privacyArr = userData["Privacies"] as! [[String:Any]]
        var privacyData = privacyArr[0]
        return  [
            "id" : privacyData["id"] as! Int,
            "user_id": self.getUserId(),
            "profile_pic" : privacyData["profile_pic"] as! Int,
            "email" : privacyData["email"] as! Int,
            "age" : privacyData["age"] as! Int,
            "gender" : privacyData["gender"] as! Int,
            "follow" : privacyData["follow"] as! Int,
            "comment" : privacyData["comment"] as! Int,
            "message" : privacyData["message"] as! Int,
            "last_seen" : privacyData["last_seen"] as! Int,
            ]
    }
    
    func getReaderInfo(userinfo:[String:Any]) -> ProfileInfo.Data {
        
        var bookDta : NSDictionary?
        if userinfo["MyBooks"] != nil {
            bookDta = userinfo["MyBooks"] as? NSDictionary
        }
        
        var privaces: [String:Any]?
        if bookDta != nil {
            if let obj = userinfo["Privacies"] as? NSArray {
                privaces = obj[0] as? [String:Any]
            } else {
                privaces = userinfo["Privacies"] as? [String:Any]
            }
        }
        
        
        return ProfileInfo.Data(
            id: userinfo["id"] as? Int,
            firstname: userinfo["firstname"] as? String,
            lastname: userinfo["lastname"] as? String,
            email:  userinfo["email"] as? String,
            about: userinfo["about"] as? String,
            gender: userinfo["gender"] as? String,
            address: userinfo["address"] as? String,
            city: userinfo["city"] as? String,
            state: userinfo["state"] as? String,
            country: userinfo["country"] as? String,
            zipcode:userinfo["zipcode"] as? Int,
            dob: userinfo["dob"] as? String,
            age: userinfo["age"] as? Int,
            last_seen: userinfo["last_seen"] as? String,
            group_id: userinfo["group_id"] as? Int,
            role_id: userinfo["role_id"] as? Int,
            created_at: userinfo["created_at"] as? String,
            modified_at: userinfo["modified_at"] as? String,
            user_image: userinfo["user_image"] as? String,
            profile_privacy: userinfo["otp"] as? Int,
            review_privacy: userinfo["review_privacy"] as? Int,
            message_privacy: userinfo["message_privacy"] as? Int,
            is_deleted: userinfo["is_deleted"] as? Bool,
            updated_at: userinfo["updated_at"] as? String,
            active:userinfo["active"] as? Bool,
            status: userinfo["state"] as? Bool,
            lat: userinfo["lat"] as? Double,
            lng: userinfo["lng"] as? Double,
            is_logged_in: userinfo["is_logged_in"] as? Bool,
            social_type: userinfo["social_type"] as? Bool,
            social_token: userinfo["social_token"] as? Int,
            otp: userinfo["otp"] as? Int,
            token: userinfo["token"] as? String,
            favouriteBooks: bookDta != nil ? bookDta!["pendingBooks"] as? Int : 0,
            pendingBooks: bookDta != nil ? bookDta!["pendingBooks"] as? Int : 0,
            readBooks: bookDta != nil ? bookDta!["readBooks"] as? Int : 0,
            readingBooks: bookDta != nil ? bookDta!["readingBooks"] as? Int : 0,
            totalBooks:  bookDta != nil ? bookDta!["totalBooks"] as? Int : 0,
            viewage : bookDta != nil ? privaces!["age"] as? Int : 0,
            viewcomment : bookDta != nil ? privaces!["comment"] as? Int : 0,
            viewemail : bookDta != nil ? privaces!["email"] as? Int : 0,
            viewfollow : bookDta != nil ? privaces!["follow"] as? Int : 0,
            viewgender : bookDta != nil ? privaces!["gender"] as? Int : 0,
            viewid : bookDta != nil ? privaces!["id"] as? Int : 0,
            viewmessage : bookDta != nil ? privaces!["message"] as? Int : 0,
            viewprofile_pic : bookDta != nil ? privaces!["profile_pic"] as? Int : 0,
            viewuser_id : bookDta != nil ? privaces!["user_id"] as? Int : 0)
    }
    
    func getJsonString(_ object: Any) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

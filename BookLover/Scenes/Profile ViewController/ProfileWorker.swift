
import UIKit
import Alamofire

class ProfileWorker
{
    func hitGerUserProfileApi(withId: String, apiResponse:@escaping(responseHandler))
    {
//        let endUrl = ApiEndPoints.GetUserProfile + withId + ".json"
//        //let headersArray = CommonFunctions.sharedInstance.getHeaders()
//        NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .post, headers: nil, parameters: nil, encoding: nil) { (response) in
//            apiResponse(response)
//        }
        
        var param: [String:Any]?
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            if CommonFunctions.sharedInstance.getUserId() == withId {
                param = ["id":CommonFunctions.sharedInstance.getUserId()]
            } else {
                param = ["user_id":CommonFunctions.sharedInstance.getUserId(), "id": withId]
            }
        } else {
            param = ["id":withId]
        }
        
        
        let hed = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userInfo, httpMethod: .post, headers: hed, parameters: param, encoding: nil) { (response) in
            printToConsole(item: "Reach at Worker")

            apiResponse(response)
        }
    }
    
    func hitBlockUserApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
//        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.blockUser, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    
    
    func hitReportUserApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        //let headersArray = CommonFunctions.sharedInstance.getHeaders()
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.reportUser, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    func hitFriendRequsetApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.SendFriendRequest, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    
    func hitCancelFriendRequsetApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.CancelFriendRequest, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}

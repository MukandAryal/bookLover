
import UIKit
import Alamofire

class AllNotificationWorker
{
    func hitGetNotificationApi(parameters:[String:Any],apiResponse:@escaping(responseHandler))
    {
         let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.GetNotification, httpMethod: .post, headers: headersArray, parameters:parameters,encoding: nil) { (response) in
            apiResponse(response)
            printToConsole(item: response)
        }
    }
    
    func hitGetFriendsRequestApi(apiResponse:@escaping(responseHandler)) {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            // ("\(userId)")
            let endUrl = ApiEndPoints.GetFriendRequest + ("\(userId)")+"/0" + ".json"
            printToConsole(item: endUrl)
            let headersArray = CommonFunctions.sharedInstance.getHeaders()
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get, headers: headersArray, parameters: nil,encoding: nil) { (response) in
                apiResponse(response)
            }
    }
    
    func hitAcceptFriendRequsetApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.CancelFriendRequest, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    func hitDeclineFriendRequsetApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.CancelFriendRequest, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    func hitShareBookNotificationRedirectApi(param:[String:Any], apiResponse:@escaping(responseHandler)) {
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.RedirectNotification, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    func hitOtherNotificationRedirectApi(param:[String:Any], apiResponse:@escaping(responseHandler)) {
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.RedirectNotification, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}


import UIKit
import Alamofire

class AddFriendWorker
{
    func hitGetFriendApi(parameters:[String:Any],apiResponse:@escaping(responseHandler))
    {
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.GetFriends, httpMethod: .post, headers: headersArray, parameters:parameters,encoding: URLEncoding.default) { (response) in
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
    
    func hitCancalRequsetApi (param:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.CancelFriendRequest, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}

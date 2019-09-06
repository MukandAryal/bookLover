
import UIKit
import Alamofire

class ShareTheBookWorker
{
    func hitFriendsListApi(apiResponse:@escaping(responseHandler)) {
        
            let endUrl = ApiEndPoints.friendsList + CommonFunctions.sharedInstance.getUserId() + "/1.json"
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get, headers: CommonFunctions.sharedInstance.getHeaders(), parameters: nil, encoding: nil) { (response) in
                apiResponse(response)
            }
    }
    
    func hitShareTheBookApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.shareTheBook, httpMethod: .post, headers: headersArray, parameters: parameters, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}




import UIKit
import Alamofire

class ShelfTypeWorker
{
    func hitShelfTypeApi(params: [String:Any]?, apiResponse:@escaping(responseHandler)) {
        
        var headersArray: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
            headersArray.updateValue(token, forKey: "Authorization")
        }
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.getBookShelvesStatus, httpMethod: .post, headers: headersArray, parameters: params, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}

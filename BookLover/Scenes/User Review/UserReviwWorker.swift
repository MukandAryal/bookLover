
import UIKit
import Alamofire

class UserReviwWorker
{
    func hitApiUserReview(reviewId: String, apiResponse: @escaping(responseHandler))
    {

        var param:[String:Any] = ["id":reviewId]
        var headersArray:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
            headersArray.updateValue(token, forKey: "Authorization")
            param.updateValue(CommonFunctions.sharedInstance.getUserId(), forKey: "user_id")
        }
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userReview, httpMethod: .post, headers: headersArray, parameters: param, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
    
    func hitDeleteReviewApi(reviewId: String, apiResponse: @escaping(responseHandler)) {
        
        let heder = CommonFunctions.sharedInstance.getHeaders()
        let strUrl = ApiEndPoints.deleteReview + reviewId + ".json"
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: strUrl, httpMethod: .get, headers: heder) { (response) in
            apiResponse(response)
        }
    }
}

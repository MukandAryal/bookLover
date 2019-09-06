
import UIKit
import Alamofire

class RatingWorker
{
    func hitWriteRatingApi(parameters:[String:Any],apiResponse:@escaping
        (responseHandler)){
        let hed = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.writeRating, httpMethod: .post, headers: hed, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    func hitEditWriteRatingApi(parameters:[String:Any], apiResponse:@escaping
        (responseHandler)){
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let hed:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        //let hed = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.editWriteRating, httpMethod: .post, headers: hed, parameters: parameters, encoding: URLEncoding.default) { (response) in
            apiResponse(response)
        }
    }
}

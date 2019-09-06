
import UIKit
import Alamofire

class ShowAllReviewWorker
{
    func hitAllReviewApi(bookId: String, apiResponse:@escaping(responseHandler)) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true  {
            
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param = ["user_id":"\(userId)","book_id":"8"]
            let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
            
            let headersArray:HTTPHeaders = ["Content-Type":"application/json","Authorization":token]
            
            
            
        } else {
//            let param = ["category_id":"2"]
//            let headersArray:HTTPHeaders = ["Content-Type":"application/json"]
//
//            NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.getAllBooks, httpMethod: .post, headers: headersArray, parameters: param) { (response) in
//                apiResponse(response)
          //  }
        }
        
        var param:[String:Any] = ["book_id":bookId]
        var headersArray:HTTPHeaders?
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            headersArray = CommonFunctions.sharedInstance.getHeaders()
            param.updateValue(CommonFunctions.sharedInstance.getUserId(), forKey: "user_id")
        } else {
            headersArray = ["Content-Type":"application/json"]
        }
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.allReviews, httpMethod: .post, headers: headersArray, parameters: param, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    
    
}

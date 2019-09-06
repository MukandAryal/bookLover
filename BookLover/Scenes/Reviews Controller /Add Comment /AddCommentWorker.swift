
import UIKit

class AddCommentWorker
{
    func hitAddCommntApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        
        let hed = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.addComment, httpMethod: .post, headers: hed, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
//        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.addComment, httpMethod: .post, parameters: parameters) { (response) in
//            apiResponse(response)
//        }
    }
}

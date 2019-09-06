
import UIKit
import Alamofire

class AllBooksWorker
{
    func hitAllBookApi(params: [String:Any]?, apiResponse:@escaping(responseHandler)) {
        
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.getAllBooks, httpMethod: .post, headers: headersArray, parameters: params, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
}


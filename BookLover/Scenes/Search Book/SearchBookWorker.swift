
import UIKit
import Alamofire

class SearchBookWorker
{
    func hitApiSeachBook(request: SearchBook.Request.searchTextRequest,apiResponse: @escaping(responseHandler))
    {

        var param:[String:Any] = ["query":request.updatedSearchString!,"page":request.page!]
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            param.updateValue(CommonFunctions.sharedInstance.getUserId(), forKey: "user_id")
        }
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.getAllBooks, httpMethod: .post, headers: headersArray, parameters: param, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
}

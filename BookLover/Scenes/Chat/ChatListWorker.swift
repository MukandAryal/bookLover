
import UIKit

class ChatListWorker
{
    func hitGetChatListApi(parameters:[String:Any],apiResponse:@escaping(responseHandler))
    {
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.GetChatList, httpMethod: .post, headers: headersArray, parameters:parameters,encoding: nil) { (response) in
            apiResponse(response)
        }
    }
}

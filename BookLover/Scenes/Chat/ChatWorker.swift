

import UIKit
import Alamofire


class ChatWorker
{
    func hitChatHistoryApi(parameters:[String:Any],apiResponse:@escaping(responseHandler))
    {
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint:ApiEndPoints.ChatHistory, httpMethod: .post, headers: headersArray, parameters:parameters,encoding: nil) { (response) in
            apiResponse(response)
        }
    }
}

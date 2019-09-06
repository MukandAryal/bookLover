

import UIKit

class ResetPasswordWorker
{
    func hitApiResetPassword(parameters:[String:Any],apiResponse:@escaping(responseHandler)){
         let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.ResetPasword, httpMethod: .post,headers: headersArray, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
}

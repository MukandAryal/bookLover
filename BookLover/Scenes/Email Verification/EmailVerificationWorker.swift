

import UIKit

class EmailVerificationWorker
{
    func hitVerifyOtpApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
          let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.VerifyOtp, httpMethod: .post,headers: headersArray, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    func hitOptSendApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.SendOtp, httpMethod: .post, headers: headersArray, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
}

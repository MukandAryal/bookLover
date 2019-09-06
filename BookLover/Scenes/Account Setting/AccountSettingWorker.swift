
import UIKit

class AccountSettingWorker
{
    // MARK : Send Otp Api --
    func hitOptSendApi(parameters:[String:Any], apiResponse:@escaping(responseHandler)) {
         let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.SendOtp, httpMethod: .post, headers: headersArray, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
  // MARK : Change Email Api --
    func hitChangeEmailApi(parameters:[String:Any],apiResponse:@escaping(responseHandler)){
        let headersArray = CommonFunctions.sharedInstance.getHeaders()
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.ChangeEmail, httpMethod: .post, headers: headersArray, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    
    func hitDeleteAccountApi(apiResponse:@escaping(responseHandler)) {
        
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let headersArray = CommonFunctions.sharedInstance.getHeaders()
            let endUrl = ApiEndPoints.AccountDelete + ("\(userId)") + ".json"
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get, headers: headersArray, parameters: nil, encoding: nil) { (response) in
                apiResponse(response)
            }
        }
}

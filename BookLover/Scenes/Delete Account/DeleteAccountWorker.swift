

import UIKit

class DeleteAccountWorker
{
    func hitDeleteAccountApi(apiResponse:@escaping(responseHandler)) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let headersArray = CommonFunctions.sharedInstance.getHeaders()
            let endUrl = ApiEndPoints.AccountDelete + ("\(userId)") + ".json"
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get, headers: headersArray, parameters: nil, encoding: nil) { (response) in
                apiResponse(response)
            }
        }
    }
}

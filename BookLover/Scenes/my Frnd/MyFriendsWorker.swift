
import UIKit

class MyFriendsWorker
{
    func hitFriendsListApi(apiResponse:@escaping(responseHandler)) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
           // ("\(userId)")
            let endUrl = ApiEndPoints.friendsList + ("\(userId)") + "/1.json"
            let headersArray = CommonFunctions.sharedInstance.getHeaders()
            NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .get, headers: headersArray, parameters: nil,encoding: nil) { (response) in
                apiResponse(response)
            }
        }else{
        }
    }
}

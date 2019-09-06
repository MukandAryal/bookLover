
import UIKit

protocol SearchMyFriendsBusinessLogic
{
    func getFriendList(request:SearchMyFriends.Request)
     func sendFriendRequestApi(request: SearchMyFriends.Request.addFriend)
}

protocol SearchMyFriendsDataStore
{
    //var name: String { get set }
}

class SearchMyFriendsInteractor: SearchMyFriendsBusinessLogic, SearchMyFriendsDataStore
{
    var presenter: SearchMyFriendsPresentationLogic?
    var worker: SearchMyFriendsWorker?
    func getFriendList(request:SearchMyFriends.Request) {
        worker = SearchMyFriendsWorker()
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any] = [
                "query" : request.query!,
                "user_id": userId
            ]
            worker?.hitGetFriendApi(parameters:param, apiResponse: { (response) in
                self.presenter?.presentgetFriendsListResponse(response: response)
            })
        }
    }
    
    func sendFriendRequestApi(request: SearchMyFriends.Request.addFriend) {
        worker = SearchMyFriendsWorker()
        let param: [String:Any] = ["user_id":CommonFunctions.sharedInstance.getUserId(), "ffriend_id":request.ffriend_id!]
        worker?.hitFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentSendFriendRequestResponse(response: response, atIndex: request.index!)
        })
    }
}

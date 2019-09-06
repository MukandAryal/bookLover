

import UIKit
protocol AddFriendBusinessLogic
{
    func apiAddFriend()
    func sendFriendRequestApi(request: AddFriend.Request.addFriend)
    func cancelFriendRequestApi(request: AddFriend.Request.cancalRequest)
    func IsFilterGetFriend(isFilter: Bool,isGender:String,nearMe:String,age:[Int],country:String,state:String,strCountryId:String)
    
}

protocol AddFriendDataStore
{

}

class AddFriendInteractor: AddFriendBusinessLogic, AddFriendDataStore
{
    var Filter : Bool?
    var Gender : String?
    var NearMe   : String?
    var Age      : [Int]?
    var Country  : String?
    var State    : String?
    
    func IsFilterGetFriend(isFilter: Bool, isGender: String, nearMe: String, age: [Int], country: String, state: String,strCountryId:String) {
        Filter = isFilter
        Gender = isGender
        NearMe   = nearMe
        Age      = age
        Country  = country
        State    = state
    }
    var presenter: AddFriendPresentationLogic?
    var worker: AddFriendWorker?
    
    func apiAddFriend() {
        worker = AddFriendWorker()
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any]?
            if Filter != nil{
                param = [
                    "user_id":userId,
                    "age":Age!.description,
                    "gender":Gender!,
                    "near_me":NearMe!,
                    "country":Country!,
                    "state":State!
                ]
            } else {
                param = ["user_id": userId]
            }
            
            worker?.hitGetFriendApi(parameters:param!, apiResponse: { (response) in
                printToConsole(item: response)
                self.presenter?.presentGetFriendsResponse(response: response)
            })
        }
    }
    
    func sendFriendRequestApi(request: AddFriend.Request.addFriend) {
        worker = AddFriendWorker()
        let param: [String:Any] = ["user_id":CommonFunctions.sharedInstance.getUserId(), "ffriend_id":request.ffriend_id!]
        worker?.hitFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentSendFriendRequestResponse(response: response, atIndex: request.index!)
        })
    }
    
    func cancelFriendRequestApi(request: AddFriend.Request.cancalRequest) {
        worker = AddFriendWorker()
        let param: [String:Any] = ["action_user_id":CommonFunctions.sharedInstance.getUserId(), "id":request.id!,
                                   "status":2]
        worker?.hitCancalRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentCancalFriendRequestResponse(response: response, atIndex: request.index!)
        })
    }
}


import UIKit

protocol AddFriendPresentationLogic
{
    func presentGetFriendsResponse(response: ApiResponse)
    func presentSendFriendRequestResponse(response: ApiResponse, atIndex: Int)
    func presentCancalFriendRequestResponse(response: ApiResponse, atIndex: Int)
}

class AddFriendPresenter: AddFriendPresentationLogic
{
    weak var viewController: AddFriendDisplayLogic?
    
    
    func presentGetFriendsResponse(response: ApiResponse) {
        
        var model = AddFriend.ViewModel()
        if response.code == SuccessCode {
            var getFrindsList = [AddFriend.ViewModel.userInfo]()
            let result = response.result as? NSDictionary
            for userObj in (result!["users"] as? [[String:Any]])! {
                
                //let userPrivacy = (userObj["Privacies"] as? [NSArray]) as? [String:Any]
                let userPrivacy = (userObj["Privacies"] as! [[String:Any]])[0]

                let frndsIds = userObj["friend"] as? [String:Any]
                var friend : AddFriend.ViewModel.FriendId?
                if frndsIds?.count != 0 {
                    friend = AddFriend.ViewModel.FriendId(
                        id: frndsIds?["id"] as? Int,
                        user_id: frndsIds?["user_id"] as? Int,
                        ffriend_id: frndsIds?["ffriend_id"] as? Int,
                        status: frndsIds?["status"]  as? Int,
                        request_user_id: frndsIds?["request_user_id"] as? Int,
                        action_user_id: frndsIds?["action_user_id"] as? Int)
                }
                
                
                let privacy = AddFriend.ViewModel.PrivaciesInfo(
                    age: userPrivacy["age"] as? Int,
                    comment: userPrivacy["comment"] as? Int,
                    email: userPrivacy["email"] as? Int,
                    follow: userPrivacy["follow"] as? Int,
                    gender: userPrivacy["gender"] as? Int,
                    id: userPrivacy["id"] as? Int,
                    last_seen: userPrivacy["last_seen"] as? Int,
                    message: userPrivacy["message"] as? Int,
                    profile_pic: userPrivacy["profile_pic"] as? Int,
                    user_id: userPrivacy["user_id"] as? Int)
                
                let user = AddFriend.ViewModel.userInfo(
                    id: userObj["id"] as? Int,
                    firstname: userObj["firstname"] as? String,
                    lastname: userObj["lastname"] as? String,
                    gender: userObj["gender"] as? String,
                    city: userObj["city"] as? String,
                    state: userObj["state"] as? String,
                    country: userObj["country"] as? String,
                    age: userObj["age"] as? Int,
                    user_image:  userObj["user_image"] as? String,
                    weightage:  userObj["weightage"] as? Int,
                    requestId: 0,
                    categary: userObj["categories"] as? [String],
                    frnd: friend,
                    Privacies: privacy)
                getFrindsList.append(user)
            }
            model = AddFriend.ViewModel.init(frindList: getFrindsList, error: nil)
        }else{
            model = AddFriend.ViewModel(frindList: nil, error: response.error)
        }
        viewController?.displayGetFriendsList(viewModel: model)
    }
    
    
    func presentSendFriendRequestResponse(response: ApiResponse, atIndex: Int) {
        var model = AddFriend.ViewModel.ReportUser()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            let id = res["id"] as! Int
            model = AddFriend.ViewModel.ReportUser(error: nil, success: (res["result"] as? String)!, requestId: id)
        } else {
            model = AddFriend.ViewModel.ReportUser(error: response.error, success: nil, requestId: nil)
        }
        viewController?.displaySendRequsetInfo(viewModel:model, atIndex: atIndex)
    }
    
    func presentCancalFriendRequestResponse(response: ApiResponse, atIndex: Int) {
        var model = AddFriend.ViewModel.ReportUser()
        if response.code == SuccessCode {
            model = AddFriend.ViewModel.ReportUser(error: nil, success: localizedTextFor(key: SucessfullyMessage.FriendrequestcancelledSucessfully.rawValue), requestId: 0)
        } else {
            model = AddFriend.ViewModel.ReportUser(error: response.error, success: nil, requestId: nil)
        }
        viewController?.displayCancelRequsetInfo(viewModel: model, atIndex: atIndex)
    }
}



import UIKit

protocol SearchMyFriendsPresentationLogic
{
    func presentgetFriendsListResponse(response: ApiResponse)
    func presentSendFriendRequestResponse(response: ApiResponse, atIndex: Int)
}

class SearchMyFriendsPresenter: SearchMyFriendsPresentationLogic
{
    weak var viewController: SearchMyFriendsDisplayLogic?
    func presentgetFriendsListResponse(response: ApiResponse) {
        var model = SearchMyFriends.ViewModel()
        if response.code == SuccessCode {
            var getFrindsList = [SearchMyFriends.ViewModel.userInfo]()
            let result = response.result as? NSDictionary
            for userObj in (result!["users"] as? [[String:Any]])! {
                let user = SearchMyFriends.ViewModel.userInfo(
                    id: userObj["id"] as? Int,
                    firstname: userObj["firstname"] as? String,
                    lastname: userObj["lastname"] as? String,
                    gender: userObj["gender"] as? String,
                    city: userObj["city"] as? String,
                    state: userObj["state"] as? String,
                    country: userObj["country"] as? String,
                    age: userObj["age"] as? Int,
                    weightage:  userObj["weightage"] as? Int,
                    user_image:  userObj["user_image"] as? String,
                    ffriend_id: userObj["ffriend_id"]as? Int,
                    categary: userObj["categories"] as? [String])
                getFrindsList.append(user)
            }
            model = SearchMyFriends.ViewModel.init(frindList: getFrindsList, error: nil)
        }else{
            model = SearchMyFriends.ViewModel(frindList: nil, error: response.error)
        }
        viewController?.displayGetFriendsList(viewModel: model)
    }
    
    func presentSendFriendRequestResponse(response: ApiResponse, atIndex: Int) {
        var model = SearchMyFriends.ViewModel.ReportUser()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            let id = res["id"] as! Int
            model = SearchMyFriends.ViewModel.ReportUser(error: nil, success: (res["result"] as? String)!, requestId: id)
        } else {
            model = SearchMyFriends.ViewModel.ReportUser(error: response.error, success: nil, requestId: nil)
        }
        viewController?.displaySendRequsetInfo(viewModel:model, atIndex: atIndex)
    }
}

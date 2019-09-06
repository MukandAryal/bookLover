
import UIKit

protocol ShareTheBookPresentationLogic
{
    func getFriendsListResponse(response: ApiResponse)
    func presentShareTheBookResponse(response: ApiResponse)

}

class ShareTheBookPresenter: ShareTheBookPresentationLogic
{
    weak var viewController: ShareTheBookDisplayLogic?
    func getFriendsListResponse(response: ApiResponse) {
        var model = ShareTheBook.ViewModel()
        if response.code == SuccessCode {
            
            let result = response.result as! NSDictionary
            var friendList = [ShareTheBook.ViewModel.FreindInfo]()
            for obj in (result["friends"] as? [[String:Any]])! {
                
                let strU_Id = "\(((obj["user"] as? [String:Any])!["id"] as? Int)!)"
                var frndObj : [String:Any]?
                if CommonFunctions.sharedInstance.getUserId() != strU_Id {
                    frndObj = (obj["user"] as? [String:Any])!
                } else {
                    frndObj = (obj["ffriend"] as? [String:Any])!
                }
                
                let friend = ShareTheBook.ViewModel.FreindInfo(
                    about: frndObj!["about"] as? String,
                    active: frndObj!["active"] as? Bool,
                    address: frndObj!["address"] as? String,
                    age: frndObj!["age"] as? String,
                    city: frndObj!["city"] as? String,
                    country: frndObj!["country"] as? String,
                    created_at: frndObj!["created_at"] as? String,
                    dob: frndObj!["dob"] as? String,
                    email: frndObj!["email"] as? String,
                    firstname: frndObj!["firstname"] as? String,
                    gender: frndObj!["gender"] as? String,
                    group_id: frndObj!["group_id"] as? String,
                    id: frndObj!["id"] as? Int16,
                    is_deleted: frndObj!["is_deleted"] as? Bool,
                    is_logged_in: frndObj!["is_logged_in"] as? Bool,
                    last_seen: frndObj!["last_seen"] as? String,
                    lastname: frndObj!["lastname"] as? String,
                    lat:  frndObj!["lat"] as? Float,
                    lng: frndObj!["lng"] as? Float,
                    message_privacy: frndObj!["message_privacy"] as? Bool,
                    modified_at:  frndObj!["modified_at"] as? String,
                    otp: frndObj!["otp"] as? Int16,
                    profile_privacy: frndObj!["profile_privacy"] as? Bool,
                    review_privacy: frndObj!["review_privacy"] as? Bool,
                    role_id: frndObj!["role_id"] as? Int16,
                    social_token: frndObj!["social_token"] as? Int16,
                    social_type: frndObj!["social_type"] as? String,
                    state: frndObj!["state"] as? String,
                    status: frndObj!["status"] as?  Bool,
                    updated_at: frndObj!["updated_at"] as? String,
                    user_image: frndObj!["user_image"] as? String,
                    zipcode: frndObj!["zipcode"] as? Int16,
                    isSelected : false)
                
//                let friendId = ShareTheBook.ViewModel.friend(
//                    id: obj["id"] as? Int,
//                    user_id: obj["user_id"] as? Int,
//                    ffriend_id: obj["ffriend_id"] as? Int,
//                    status: obj["status"] as? Bool,
//                    request_user_id: obj["request_user_id"] as? Int,
//                    action_user_id: obj["action_user_id"] as? Int,
//                    created_at: obj["created_at"] as? String,
//                    modified_at: obj["modified_at"] as? String,
//                    friendData: friend)
                 friendList.append(friend)
            }
            model = ShareTheBook.ViewModel(friendList: friendList, error: nil)
        }else{
            model = ShareTheBook.ViewModel(friendList: nil, error: response.error)
        }
        viewController?.displayfriendList(viewModel: model)
    }
    
    func presentShareTheBookResponse(response: ApiResponse) {
        
        var viewModel = ShareTheBook.ViewModel.ShareTheBook()
        
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = ShareTheBook.ViewModel.ShareTheBook(error: nil, message: result["result"] as? String)
        } else {
            viewModel = ShareTheBook.ViewModel.ShareTheBook(error: response.error, message: nil)
        }
        viewController?.displayShareTheBookResponse(viewModel: viewModel)
    }
}


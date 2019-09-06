
import UIKit

protocol MyFriendsPresentationLogic
{
    func presentgetFriendsListResponse(response: ApiResponse)
}

class MyFriendsPresenter: MyFriendsPresentationLogic
{
    weak var viewController: MyFriendsDisplayLogic?
    func presentgetFriendsListResponse(response: ApiResponse) {
        var model = MyFriends.ViewModel()
        if response.code == SuccessCode {
            
            let result = response.result as! NSDictionary
            var friendList = [MyFriends.ViewModel.FreindInfo]()
            for obj in (result["friends"] as? [[String:Any]])! {
                
                let strU_Id = "\(((obj["user"] as? [String:Any])!["id"] as? Int)!)"
                var frndObj : [String:Any]?
                if CommonFunctions.sharedInstance.getUserId() != strU_Id {
                    frndObj = (obj["user"] as? [String:Any])!
                } else {
                    frndObj = (obj["ffriend"] as? [String:Any])!
                }
                
//                let userPrivacy = (frndObj!["Privacies"] as? [NSArray]) as? [String:Any]
                
                let userPrivacy = (frndObj!["Privacies"] as! [[String:Any]])[0]
                let privacy = MyFriends.ViewModel.PrivaciesInfo(
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
                
                let friend = MyFriends.ViewModel.FreindInfo(
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
                    isSelected : false,
                    Privacies: privacy)
                friendList.append(friend)
            }
            model = MyFriends.ViewModel(friendList: friendList, error: nil)
        }else{
            model = MyFriends.ViewModel(friendList: nil, error: response.error)
        }
        viewController?.displayfriendList(viewModel: model)
    }

}


import UIKit

protocol ChatListPresentationLogic
{
    func presentGetChatListResponse(response: ApiResponse)

}

class ChatListPresenter: ChatListPresentationLogic
{
    weak var viewController: ChatListDisplayLogic?
    
    // MARK: Do something
    func presentGetChatListResponse(response: ApiResponse) {
        var model = ChatList.ViewModel()
        if response.code == SuccessCode {
            if response.code == SuccessCode {
                let result = response.result as! NSDictionary
                var friendList = [ChatList.ViewModel.FreindInfo]()
                
                for obj in (result["chats"] as? [[String:Any]])! {
                    
//                    let strU_Id = "\(((obj["user"] as? [String:Any])!["id"] as? Int)!)"
                    if (obj["isPrivateMessage"] as? Bool) == true || (obj["is_friend"] as? Bool) == true {
                        var frndObj : [String:Any]?
                        if obj["user"] != nil && Int(CommonFunctions.sharedInstance.getUserId()) != ((obj["user"] as? [String:Any])!["id"] as? Int) {
                            frndObj = (obj["user"] as? [String:Any])!
                        } else {
                            frndObj = (obj["tuser"] as? [String:Any])!
                        }
                        
                        let friend = ChatList.ViewModel.FreindInfo(
                            id: frndObj!["id"] as? Int,
                            firstname: frndObj!["firstname"] as? String,
                            lastname: frndObj!["lastname"] as? String,
                            gender: frndObj!["gender"] as? String,
                            city: frndObj!["city"] as? String,
                            state: frndObj!["state"] as? String,
                            country: frndObj!["country"] as? String,
                            age:frndObj!["age"] as? Int,
                            user_image: frndObj!["user_image"] as? String,
                            Frndid: frndObj!["id"] as? Int,
                            from_user_id: obj["from_user_id"] as? Int,
                            to_user_id:obj["to_user_id"] as? Int,
                            message: obj["message"] as? String,
                            is_read: obj["is_read"] as? Int,
                            is_from_deleted: obj["is_from_deleted"] as? Int,
                            is_to_deleted: obj["is_to_deleted"] as? Int,
                            created: obj["created"] as? String,
                            isSelected : false,
                            profile_privacy: obj["profile_pic"] as? Int
                        )
                        friendList.append(friend)
                    }
                }
                model = ChatList.ViewModel(friendList: friendList, error: nil)
            }else{
                model = ChatList.ViewModel(friendList: nil, error: response.error)
            }
            viewController?.displayfriendList(viewModel: model)
        }
    }

    
}

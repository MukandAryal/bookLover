
import UIKit

protocol AllNotificationPresentationLogic
{
    func presentGetNotificationResponse(response: ApiResponse)
    func presentGetFriendRequestResponse(response: ApiResponse)
    func presentAcceptFriendRequestResponse(response: ApiResponse, atIndex: Int)
    func presentDeclineFriendRequestResponse(response: ApiResponse, atIndex: Int)
    func presentRedirectNotificationResponse(response:ApiResponse)
    func presentOtherRedirectNotificationResponse(response:ApiResponse)
}

class AllNotificationPresenter: AllNotificationPresentationLogic
{
    weak var viewController: AllNotificationDisplayLogic?
    
    func presentGetNotificationResponse(response: ApiResponse) {
        var model = AllNotification.ViewModel()
        if response.code == SuccessCode {
            var getNotificationList = [AllNotification.ViewModel.userInfo]()
            let result = response.result as? NSDictionary
            for notificationObj in (result!["notifications"] as? [[String:Any]])! {
                
                if let nuser = notificationObj["nuser"] as? [String:Any] {
                    
                    let userPrivacy = (nuser["Privacies"] as! [[String:Any]])[0]
                    let privacy = AllNotification.ViewModel.PrivaciesInfo(
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
                    
                    let user = AllNotification.ViewModel.userInfo(
                        id: notificationObj["id"] as? Int,
                        user_id: notificationObj["user_id"] as? Int,
                        nuser_id: notificationObj["nuser_id"] as? Int,
                        message: notificationObj["message"] as? String,
                        book_id:notificationObj["book_id"] as? Int,
                        review_id:notificationObj["review_id"]  as? Int,
                        is_read: notificationObj["is_read"] as? Int,
                        type: notificationObj["type"] as? String,
                        created: notificationObj["created"] as? String,
                        nuserid: nuser["id"] as? Int,
                        nuserfirstname: nuser["firstname"] as? String,
                        nuserlastname:nuser["lastname"] as? String,
                        nuseruser_image: nuser["user_image"] as? String,
                        Privacies: privacy)
                    
                    getNotificationList.append(user)
                }
            }
            model = AllNotification.ViewModel.init(notificationInfo: getNotificationList, error: nil)
        }else{
            model = AllNotification.ViewModel(notificationInfo: nil, error: response.error)
        }
        viewController?.displayGetNotifocation(viewModel: model)
    }
    
    func presentGetFriendRequestResponse(response: ApiResponse) {
        
        var model = AllNotification.friendRequest()
        if response.code == SuccessCode {
            var getFrindsRequestList = [AllNotification.friendRequest.friendRequestUserInfo]()
            let result = response.result as? NSDictionary
            for notificationObj in (result!["friends"] as? [[String:Any]])! {
                
                let strU_Id = "\(((notificationObj["ffriend"] as? [String:Any])!["id"] as? Int)!)"
                var frndsIds : [String:Any]?
                if CommonFunctions.sharedInstance.getUserId() != strU_Id {
                    frndsIds = (notificationObj["ffriend"] as? [String:Any])!
                } else {
                    frndsIds = (notificationObj["user"] as? [String:Any])!
                }
                
                let userPrivacy = (frndsIds!["Privacies"] as! [[String:Any]])[0]
                let mybooks = frndsIds!["MyBooks"] as? [String:Any]
                var friend : AllNotification.friendRequest.FriendId?
                if frndsIds?.count != 0 {
                    friend = AllNotification.friendRequest.FriendId(
                        id: notificationObj["id"] as? Int,
                        user_id: notificationObj["user_id"] as? Int,
                        ffriend_id: notificationObj["ffriend_id"] as? Int,
                        status: notificationObj["status"] as? Int,
                        request_user_id: notificationObj["request_user_id"] as? Int,
                        action_user_id: notificationObj["action_user_id"] as? Int,
                        created_at: notificationObj["created_at"] as? String,
                        modified_at: notificationObj["modified_at"] as? String)
                }
                
                let privacy = AllNotification.friendRequest.PrivaciesInfo(
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
                
                
                let user = AllNotification.friendRequest.friendRequestUserInfo(
                    id: frndsIds!["id"] as? Int,
                    firstname: frndsIds!["firstname"] as? String,
                    lastname: frndsIds!["lastname"] as? String,
                    gender: frndsIds!["gender"] as? String,
                    city: frndsIds!["city"] as? String,
                    state: frndsIds!["state"] as? String,
                    country: frndsIds!["country"] as? String,
                    age: frndsIds!["age"] as? Int,
                    user_image:  frndsIds!["user_image"] as? String,
                    categary: mybooks!["categories"] as? [String],
                    frnd: friend,
                    Privacies: privacy)
                
                getFrindsRequestList.append(user)
                printToConsole(item: getFrindsRequestList)
            }
            model = AllNotification.friendRequest.init(frindRequestInfo: getFrindsRequestList, error: nil)
        }else{
            model = AllNotification.friendRequest.init(frindRequestInfo: nil, error: response.error)
        }
        viewController?.displayGetFriendRequest(viewModel: model)
    }
    
    func presentAcceptFriendRequestResponse(response: ApiResponse, atIndex: Int) {
        var model = AllNotification.friendRequest.ReportUser()
        if response.code == SuccessCode {
            model = AllNotification.friendRequest.ReportUser(error: nil, success: localizedTextFor(key: SucessfullyMessage.FriendRequestAccepted.rawValue))
        } else {
            model = AllNotification.friendRequest.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayAcceptRequsetInfo(viewModel:model, atIndex: atIndex)
    }
    
    func presentDeclineFriendRequestResponse(response: ApiResponse, atIndex: Int) {
        var model = AllNotification.friendRequest.ReportUser()
        if response.code == SuccessCode {
            model = AllNotification.friendRequest.ReportUser(error: nil, success: localizedTextFor(key: SucessfullyMessage.FriendrequestcancelledSucessfully.rawValue))
        } else {
            model = AllNotification.friendRequest.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayDeclineRequsetInfo(viewModel: model, atIndex: atIndex)
    }
    
    func presentRedirectNotificationResponse(response: ApiResponse) {
        var model = AllNotification.friendRequest.ReportUser()
        if response.code == SuccessCode {
            model = AllNotification.friendRequest.ReportUser(error: nil, success:nil)
        } else {
            model = AllNotification.friendRequest.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayRedirectNotification(viewModel: model)
    }
    
    func presentOtherRedirectNotificationResponse(response: ApiResponse) {
        var model = AllNotification.friendRequest.ReportUser()
        if response.code == SuccessCode {
            model = AllNotification.friendRequest.ReportUser(error: nil, success:nil)
        } else {
            model = AllNotification.friendRequest.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayRedirectOtherNotification(viewModel:model)
    }
}

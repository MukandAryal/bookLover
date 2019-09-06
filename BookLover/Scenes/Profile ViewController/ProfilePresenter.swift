
import UIKit

protocol ProfilePresentationLogic
{
    func presentGetUserProfileResponse(response: ApiResponse)
    func presentReportUserResponse(response: ApiResponse)
    func presentBlockUserResponse(response: ApiResponse)
    func presentSendFriendRequestResponse(response: ApiResponse)
    func presentCancelFriendRequestResponse(response: ApiResponse)
}

class ProfilePresenter: ProfilePresentationLogic
{
    weak var viewController: ProfileDisplayLogic?
    
    func presentSendFriendRequestResponse(response: ApiResponse) {
        var model = Profile.ViewModel.ReportUser()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            viewController?.strFriendObjId = "\((res["id"] as! Int))"
            model = Profile.ViewModel.ReportUser(error: nil, success: (res["result"] as? String)!)
        } else {
            model = Profile.ViewModel.ReportUser(error: response.error, success: nil)
        }
        viewController?.displaySendRequsetInfo(viewModel: model)
    }
    
    func presentCancelFriendRequestResponse(response: ApiResponse) {
        var model = Profile.ViewModel.ReportUser()
        if response.code == SuccessCode {
            model = Profile.ViewModel.ReportUser(error: nil, success: localizedTextFor(key: SucessfullyMessage.FriendrequestcancelledSucessfully.rawValue))
        } else {
            model = Profile.ViewModel.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayCancelRequsetInfo(viewModel: model)
    }
    
    func presentGetUserProfileResponse(response: ApiResponse) {
        
        var model = Profile.ViewModel()
        if response.code == SuccessCode {
            let userObj = response.result as! [String:Any]
            let proData = getReaderInfo(fromData: userObj)
            model = Profile.ViewModel(userData: proData, error: nil)
        } else {
            model = Profile.ViewModel(userData: nil, error: response.error)
        }
        viewController?.displayUserProfileInfo(viewModel: model)
   }
    
    func presentReportUserResponse(response: ApiResponse) {
        var model = Profile.ViewModel.ReportUser()
        if response.code == SuccessCode {
            model = Profile.ViewModel.ReportUser(error: nil, success: localizedTextFor(key: ProfilePrivacyText.ReportToAdminMessage.rawValue))
        } else {
            model = Profile.ViewModel.ReportUser(error: response.error, success: nil)
        }
        viewController?.displayReportUserInfo(viewModel: model)
    }
    
    func presentBlockUserResponse(response: ApiResponse)
    {
        var model = Profile.ViewModel.BlockUser()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            model = Profile.ViewModel.BlockUser(error: nil, success: res["result"] as? String)
        } else {
            model = Profile.ViewModel.BlockUser(error: response.error, success: nil)
        }
        viewController?.displayBlockUserInfo(viewModel: model)
    }
    
        func getReaderInfo(fromData:[String:Any]) -> Profile.ViewModel.UserInfo {
    
            let userinfo = fromData["userInfo"] as! NSDictionary
            let bookDta = userinfo["MyBooks"] as! NSDictionary
            var privaces: [String:Any]
            if let obj = userinfo["Privacies"] as? NSArray {
                privaces = obj[0] as! [String:Any]
            } else {
                privaces = userinfo["Privacies"] as! [String:Any]
            }
    
            var friendDta = Profile.ViewModel.UserInfo.FriendData()
            if userinfo["friend"] != nil, let friend = userinfo["friend"] as? [String:Any] {
                friendDta = Profile.ViewModel.UserInfo.FriendData(
                    id: friend["id"] as? Int,
                    user_id: friend["user_id"] as? Int,
                    ffriend_id: friend["ffriend_id"] as? Int,
                    status: friend["status"] as? Int,
                    request_user_id: friend["request_user_id"] as? Int,
                    action_user_id: friend["action_user_id"] as? Int,
                    created_at: friend["created_at"] as? String,
                    modified_at: friend["modified_at"] as? String)
            }
    
            var bookList = [Profile.ViewModel.UserInfo.FavouriteBooks]()
            for bookObj in (bookDta["favouriteBooks"] as? [[String:Any]])! {
    
                let detail = bookObj["book"] as! [String:Any]
                let book = Profile.ViewModel.UserInfo.FavouriteBooks(
                    author_name: detail["author_name"] as? String,
                    cover_photo: detail["cover_photo"] as? String,
                    isbn_no: detail["isbn_no"] as? String,
                    name: detail["name"] as? String,
                    book_id: bookObj["book"] as? Int,
                    id: bookObj["id"] as? Int,
                    is_favourite: bookObj["is_favourite"] as? Int,
                    shelf_status: bookObj["shelf_status"] as? Int)
                bookList.append(book)
            }
    
            return Profile.ViewModel.UserInfo(
                id: userinfo["id"] as? Int,
                firstname: userinfo["firstname"] as? String,
                lastname: userinfo["lastname"] as? String,
                email:  userinfo["email"] as? String,
                about: userinfo["about"] as? String,
                gender: userinfo["gender"] as? String,
                address: userinfo["address"] as? String,
                city: userinfo["city"] as? String,
                state: userinfo["state"] as? String,
                country: userinfo["country"] as? String,
                zipcode:userinfo["zipcode"] as? Int,
                dob: userinfo["dob"] as? String,
                age: userinfo["age"] as? Int,
                last_seen: userinfo["last_seen"] as? String,
                group_id: userinfo["group_id"] as? Int,
                role_id: userinfo["role_id"] as? Int,
                created_at: userinfo["created_at"] as? String,
                modified_at: userinfo["modified_at"] as? String,
                user_image: userinfo["user_image"] as? String,
                profile_privacy: userinfo["otp"] as? Int,
                review_privacy: userinfo["review_privacy"] as? Int,
                message_privacy: userinfo["message_privacy"] as? Int,
                is_deleted: userinfo["is_deleted"] as? Bool,
                updated_at: userinfo["updated_at"] as? String,
                active:userinfo["active"] as? Bool,
                status: userinfo["state"] as? Bool,
                lat: userinfo["lat"] as? Double,
                lng: userinfo["lng"] as? Double,
                is_logged_in: userinfo["is_logged_in"] as? Bool,
                social_type: userinfo["social_type"] as? Bool,
                social_token: userinfo["social_token"] as? Int,
                otp: userinfo["otp"] as? Int,
                token: userinfo["token"] as? String,
                favBooks:fromData["favouriteBooks"] as? Int,
                pendingBooks: fromData["pendingBooks"] as? Int,
                readBooks: fromData["readBooks"] as? Int,
                readingBooks: fromData["readingBooks"] as? Int,
                totalBooks: fromData["totalBooks"] as? Int,
                viewage : privaces["age"] as? Int,
                viewcomment : privaces["comment"] as? Int,
                viewemail : privaces["email"] as? Int,
                viewfollow : privaces["follow"] as? Int,
                viewgender : privaces["gender"] as? Int,
                viewid : privaces["id"] as? Int,
                viewmessage : privaces["message"] as? Int,
                viewprofile_pic : privaces["profile_pic"] as? Int,
                viewuser_id : privaces["user_id"] as? Int,
                viewLastSeen: privaces["last_seen"] as? Int,
                favouriteBooks: bookList,
                friendData: friendDta)
        }
}






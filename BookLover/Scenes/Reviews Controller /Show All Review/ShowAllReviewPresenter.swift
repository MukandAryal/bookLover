
import UIKit

protocol ShowAllReviewPresentationLogic
{
    func showAllReviewResponse(response: ApiResponse)
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int)
}

class ShowAllReviewPresenter: ShowAllReviewPresentationLogic
{
    weak var viewController: ShowAllReviewDisplayLogic?
    
    func showAllReviewResponse(response: ApiResponse) {
        
        var model = ShowAllReview.ViewModel()
        
        if response.code == SuccessCode {
            
            var reviewAllList = [ShowAllReview.ViewModel.Review]()
            let result = response.result as! NSDictionary
            
            for obj in (result["reviews"] as? [[String:Any]])! {
                
                let userObj = (obj["user"] as? [String:Any])!
                var privacyList = [ShowAllReview.ViewModel.Privacies]()
                
                for privacyObj in (userObj["Privacies"] as? [[String:Any]])! {
                    
                    let privacy = ShowAllReview.ViewModel.Privacies(
                        id: privacyObj["id"] as? Int,
                        user_id: privacyObj["user_id"] as? Int,
                        profile_pic: privacyObj["profile_pic"] as? Int,
                        email: privacyObj["email"] as? Int,
                        age: privacyObj["age"] as? Int,
                        gender: privacyObj["gender"] as? Int,
                        follow: privacyObj["follow"] as? Int,
                        comment: privacyObj["comment"] as? Int,
                        message: privacyObj["message"] as? Int)
                    
                    privacyList.append(privacy)
                }
                
//                let user = ShowAllReview.ViewModel.UserInfo(
//                    about: userObj["about"] as? String,
//                    active: userObj["active"] as? Bool,
//                    address: userObj["address"] as? String,
//                    age: userObj["age"] as? String,
//                    city: userObj["city"] as? String,
//                    country: userObj["country"] as? String,
//                    created_at: userObj["created_at"] as? String,
//                    dob: userObj["dob"] as? String,
//                    email:  userObj["email"] as? String,
//                    firstname: userObj["firstname"] as? String,
//                    gender: userObj["gender"] as? String,
//                    group_id: userObj["group_id"] as? String,
//                    id: userObj["id"] as? Int16,
//                    is_deleted: userObj["is_deleted"] as? Bool,
//                    is_logged_in: userObj["is_logged_in"] as? Bool,
//                    last_seen: userObj["last_seen"] as? String,
//                    lastname: userObj["lastname"] as? String,
//                    lat: userObj["lat"] as? Float32,
//                    lng: userObj["lng"] as? Float32,
//                    message_privacy: userObj["message_privacy"] as? Bool,
//                    modified_at: userObj["modified_at"] as? String,
//                    otp: userObj["otp"] as? Int16,
//                    profile_privacy: userObj["otp"] as? Bool,
//                    review_privacy: userObj["review_privacy"] as? Bool,
//                    role_id: userObj["role_id"] as? Int16,
//                    social_token: userObj["social_token"] as? Int16,
//                    social_type: userObj["social_type"] as? String,
//                    state: userObj["state"] as? String,
//                    status: userObj["state"] as? Bool,
//                    updated_at: userObj["updated_at"] as? String,
//                    user_image: userObj["user_image"] as? String,
//                    zipcode:userObj["zipcode"] as? Int16,
//                    privacies : privacyList)
                
                let user = CommonFunctions.sharedInstance.getReaderInfo(userinfo: userObj)
                
                let review = ShowAllReview.ViewModel.Review(
                    book_id: obj["book_id"] as? Int16,
                    commentCount: obj["commentCount"] as? Int,
                    created_at: obj["created_at"] as? String,
                    description: obj["description"] as? String,
                    id: obj["id"] as? Int16,
                    is_deleted: obj["is_deleted"] as? Bool,
                    is_like : obj["is_like"] as? Bool,
                    likeCount: obj["likeCount"] as? Int,
                    rating: obj["rating"] as? Double,
                    status:  obj["status"] as? Bool,
                    updated_at: obj["updated_at"] as? String,
                    user: user)
                
                    reviewAllList.append(review)
           }
            model = ShowAllReview.ViewModel(reviewAllList: reviewAllList, error: nil)
        }else{
            model = ShowAllReview.ViewModel(reviewAllList: nil, error: response.error)
        }
        
        viewController?.displayAllReview(viewModel: model)
    }
    
    
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int) {
        
        var model = ShowAllReview.LikeUnlikeModel()
        if response.code == SuccessCode {
            model = ShowAllReview.LikeUnlikeModel(error: nil, success: "Liked")
        } else {
            model = ShowAllReview.LikeUnlikeModel(error: response.error, success: nil)
        }
        viewController?.displayLikeUnlikeReview(viewModel: model, atIndex: atIndex)
    }
}


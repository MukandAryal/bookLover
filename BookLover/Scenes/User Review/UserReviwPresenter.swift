

import UIKit

protocol UserReviwPresentationLogic
{
    func presentReviewResponse(response:ApiResponse)
    func presentDeleteReview(response:ApiResponse)
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int)
}

class UserReviwPresenter: UserReviwPresentationLogic
{
    weak var viewController: UserReviwDisplayLogic?
    
    
    func presentReviewResponse(response: ApiResponse) {
        
        var model = UserReviw.ViewModel()
        
        if response.code == SuccessCode {
            
            let result = response.result as! NSDictionary
            var commentList = [UserReviw.ViewModel.Review.Comments]()
            let reviewObj = result["reviews"] as? [String:Any]

            for commentObj in (reviewObj!["comments"] as? [[String:Any]])!{
                
                let com_User = commentObj["user"] as? [String:Any]
                let user = CommonFunctions.sharedInstance.getReaderInfo(userinfo: com_User!)
                let commentObj = UserReviw.ViewModel.Review.Comments(
                    id: commentObj["id"] as? Int,
                    review_id: commentObj["review_id"] as? Int,
                    user_id: commentObj["user_id"] as? Int,
                    description: commentObj["description"] as? String,
                    created: commentObj["created"] as? String,
                    user: user)
                
                commentList.append(commentObj)
            }
            
            
            let rev_User = reviewObj!["user"] as? [String:Any]
            let reviewUser = CommonFunctions.sharedInstance.getReaderInfo(userinfo: rev_User!)
            
            let reviewData = UserReviw.ViewModel.Review(
                
                id: reviewObj!["id"] as? Int,
                user_id: reviewObj!["user_id"] as? Int,
                book_id: reviewObj!["book_id"] as? Int,
                description: reviewObj!["description"] as? String,
                rating: reviewObj!["rating"] as? Double,
                status: reviewObj!["status"] as? Bool,
                is_deleted: reviewObj!["is_deleted"] as? Bool,
                created_at: reviewObj!["created_at"] as? String,
                updated_at: reviewObj!["updated_at"] as? String,
                likeCount: reviewObj!["likeCount"] as? Int,
                is_like : reviewObj!["is_like"] as? Bool,
                commentCount: reviewObj!["commentCount"] as? Int,
                comment: commentList,
                user : reviewUser
                )

            model = UserReviw.ViewModel(reviewData: reviewData, error: nil)
        } else {
            model = UserReviw.ViewModel(reviewData: nil, error: response.error)
        }
        
        viewController?.displayUserResponse(viewModel: model)
        
    }
    
    
    func presentLikeUnlikeResponse(response: ApiResponse, atIndex: Int) {
        
        var model = ShowAllReview.LikeUnlikeModel()
        if response.code == SuccessCode {
            model = ShowAllReview.LikeUnlikeModel(error: nil, success: "")
        } else {
            model = ShowAllReview.LikeUnlikeModel(error: response.error, success: nil)
        }
        viewController?.displayLikeUnlikeReview(viewModel: model, atIndex: atIndex)
    }
    
    func presentDeleteReview(response: ApiResponse) {
        var model = UserReviw.ViewModel.DeleteReview()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            model = UserReviw.ViewModel.DeleteReview(error: nil, success: res["message"] as? String)
        } else {
            model = UserReviw.ViewModel.DeleteReview(error: response.error, success: nil)
        }
        viewController?.displayDeleteReview(viewModel: model)
    }
    
}

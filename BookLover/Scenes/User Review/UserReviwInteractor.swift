
import UIKit

protocol UserReviwBusinessLogic
{
    func deleteMyReview()
    func getUserReviewData()
    func likeUnlikeReview(request: ShowAllReview.Request.LikeUnlike)

}

protocol UserReviwDataStore
{
    var reviewId : String? { get set }
}

class UserReviwInteractor: UserReviwBusinessLogic, UserReviwDataStore
{
    var reviewId: String?
    var presenter: UserReviwPresentationLogic?
    
    var worker: UserReviwWorker?
    func getUserReviewData() {
        worker = UserReviwWorker()
        worker?.hitApiUserReview(reviewId: reviewId!, apiResponse: { (response) in
            self.presenter?.presentReviewResponse(response: response)
        })
    }
    
    
    func likeUnlikeReview(request: ShowAllReview.Request.LikeUnlike) {
        
        let param:[String:Any] = ["review_id":request.reviewId!, "user_id":CommonFunctions.sharedInstance.getUserId(),"review_like":request.isLike!]
        
        CommonFunctions.sharedInstance.hitReviewLikeApi(parameters: param) { (response) in
            self.presenter?.presentLikeUnlikeResponse(response: response, atIndex: request.index!)
        }
        
    }
    
    func deleteMyReview() {
        
        worker = UserReviwWorker()
        worker?.hitDeleteReviewApi(reviewId: reviewId!, apiResponse: { (response) in
            self.presenter?.presentDeleteReview(response: response)
        })
    }

}

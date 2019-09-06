

import UIKit

protocol ShowAllReviewBusinessLogic
{
    func getAllReviewData()
    func likeUnlikeReview(request: ShowAllReview.Request.LikeUnlike)
}

protocol ShowAllReviewDataStore
{
    var bookId : String? { get set }
}

class ShowAllReviewInteractor: ShowAllReviewBusinessLogic, ShowAllReviewDataStore
{
    var bookId: String?
    var presenter: ShowAllReviewPresentationLogic?
    var worker: ShowAllReviewWorker?
    
    func getAllReviewData() {
        worker = ShowAllReviewWorker()
        worker?.hitAllReviewApi(bookId: bookId!, apiResponse: { (response) in
            self.presenter?.showAllReviewResponse(response: response)
        })
    }
    
    func likeUnlikeReview(request: ShowAllReview.Request.LikeUnlike) {
       
        let param:[String:Any] = ["review_id":request.reviewId!, "user_id":CommonFunctions.sharedInstance.getUserId(),"review_like":request.isLike!]
        
        CommonFunctions.sharedInstance.hitReviewLikeApi(parameters: param) { (response) in
            self.presenter?.presentLikeUnlikeResponse(response: response, atIndex: request.index!)
        }
        
    }

    
//    func getAllReviewData() {
//        worker = ShowAllReviewWorker()
//        worker?.hitAllReviewApi(bookId: bookId!, apiResponse: { (response) in
//            self.presenter?.showAllReviewResponse(response: response)
//        })
//    }
}


import UIKit

protocol RatingPresentationLogic
{
    func presentWriteRatingResponse(response:ApiResponse)
    func presentReviewData(rating: Double, description: String, isRatingEdit: Bool)
}

class RatingPresenter: RatingPresentationLogic
{
    weak var viewController: RatingDisplayLogic?
    func presentWriteRatingResponse(response: ApiResponse) {
        var viewModel = Rating.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = Rating.ViewModel(error: nil, message: result["result"] as? String)
        } else {
            viewModel = Rating.ViewModel(error: response.error, message: nil)
        }
         viewController?.displayWriteRatingResponse(viewModel: viewModel)
    }
    
    
    
    func presentReviewData(rating: Double, description: String, isRatingEdit: Bool) {
        viewController?.displayReviewResponse(rating: rating, description: description, isRatingEdit: isRatingEdit)
    }
}


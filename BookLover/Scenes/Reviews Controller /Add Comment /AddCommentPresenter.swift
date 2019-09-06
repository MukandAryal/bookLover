
import UIKit

protocol AddCommentPresentationLogic
{
    func presentAddCommentResponse(response:ApiResponse)
}

class AddCommentPresenter: AddCommentPresentationLogic
{
    weak var viewController: AddCommentDisplayLogic?
    func presentAddCommentResponse(response: ApiResponse) {
        var viewModel = AddComment.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = AddComment.ViewModel(error: nil, message: result["result"] as? String)
        } else {
            viewModel = AddComment.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayAddCommentResponse(viewModel: viewModel)
    }
}


import UIKit

protocol ResetPasswordPresentationLogic
{
    func presentResetPasswordResponse(response: ApiResponse)
    func presentWrongPassword(confirmPassword:Bool)
}

class ResetPasswordPresenter: ResetPasswordPresentationLogic
{
    weak var viewController: ResetPasswordDisplayLogic?
    func presentResetPasswordResponse(response: ApiResponse) {
        var viewModel = ResetPassword.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = ResetPassword.ViewModel(error: nil, message: result["message"] as? String)
        } else {
            viewModel = ResetPassword.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayResetPasswordResponse(viewModel: viewModel)
    }
    
    
    func presentWrongPassword(confirmPassword:Bool) {
        viewController?.displayWrongPassword(confirmPassword:confirmPassword)
    }
}

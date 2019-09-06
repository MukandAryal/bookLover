

import UIKit

protocol EmailVerificationPresentationLogic
{
    func presentEmailVerficationResponse(response: ApiResponse)
    func presentSendOtpResponse(response: ApiResponse)
}

class EmailVerificationPresenter: EmailVerificationPresentationLogic
{
    weak var viewController: EmailVerificationDisplayLogic?
    func presentEmailVerficationResponse(response: ApiResponse) {
        var viewModel = EmailVerification.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = EmailVerification.ViewModel(error: nil, message: result["result"] as? String)
        } else {
            viewModel = EmailVerification.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayVerifyApiResponse(viewModel: viewModel)
    }
    
    func presentSendOtpResponse(response: ApiResponse) {
        var viewModel = EmailVerification.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = EmailVerification.ViewModel(error: nil, message: result["message"] as? String)
        } else {
            viewModel = EmailVerification.ViewModel(error: response.error, message: nil)
        }
        viewController?.displaySendOtpResponse(viewModel: viewModel)
    }
}



import UIKit

protocol DeleteAccountPresentationLogic
{
    func presentDeleteAccountResponse(response: ApiResponse)
}

class DeleteAccountPresenter: DeleteAccountPresentationLogic
{
    weak var viewController: DeleteAccountDisplayLogic?
    func presentDeleteAccountResponse(response: ApiResponse) {
        var viewModel = DeleteAccount.ViewModel()
        if  response.code == SuccessCode {
//            let result = response.result as? NSDictionary
//            viewModel = DeleteAccount.ViewModel(error: nil, message: result!["result"] as? String)
        } else {
            viewModel = DeleteAccount.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayDeleteAccountResponse(viewModel: viewModel)
    }
}

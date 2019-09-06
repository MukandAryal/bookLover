
import UIKit

protocol AccountSettingPresentationLogic
{
    func presentSendOtpResponse(response: ApiResponse)
    func PresenterIsVerify(isverify:Bool)
    func presetChangeEmailResponse(response: ApiResponse)
    func presentDeleteAccountResponse(response: ApiResponse)
}

class AccountSettingPresenter: AccountSettingPresentationLogic
{
    weak var viewController: AccountSettingDisplayLogic?
    func presentSendOtpResponse(response: ApiResponse) {
        var viewModel = AccountSetting.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            printToConsole(item: result)
            viewModel = AccountSetting.ViewModel(error: nil, message: result["message"] as? String)
        } else {
            viewModel = AccountSetting.ViewModel(error: response.error, message: nil)
        }
        viewController?.displaySendOtpResponse(viewModel: viewModel)
    }
    
    func PresenterIsVerify(isverify: Bool) {
        viewController?.displayIsVerifyBook(isVerify: isverify)
    }
    
    func presetChangeEmailResponse(response: ApiResponse) {
        var viewModel = AccountSetting.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = AccountSetting.ViewModel(error: nil, message: result["message"] as? String)
        } else {
            viewModel = AccountSetting.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayChnageEmailResponse(viewModel: viewModel)
    }
    
    func presentDeleteAccountResponse(response: ApiResponse) {
        var viewModel = AccountSetting.ViewModel()
        if  response.code == SuccessCode {

            viewModel = AccountSetting.ViewModel(error: nil, message: localizedTextFor(key: SucessfullyMessage.AccountDeleteSucessfully.rawValue))
        } else {
            viewModel = AccountSetting.ViewModel(error: response.error, message: nil)
        }
        viewController?.displayDeleteAccountResponse(viewModel: viewModel)
    }
}


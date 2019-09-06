

import UIKit

@objc protocol AccountSettingRoutingLogic
{
    func navigateToEmailVerificationScene()
    func navigateToResetPasswordScene()
    func navigateToDeleteAccountScene()
}

protocol AccountSettingDataPassing
{
    var dataStore: AccountSettingDataStore? { get }
}

class AccountSettingRouter: NSObject, AccountSettingRoutingLogic, AccountSettingDataPassing
{
    weak var viewController: AccountSettingViewController?
    var dataStore: AccountSettingDataStore?
    
    func navigateToEmailVerificationScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier:ViewControllerIds.EmailVerification) as? EmailVerificationViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    func navigateToResetPasswordScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ResetPassword) as? ResetPasswordViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    func navigateToDeleteAccountScene() {
        dataStore?.Isverify = false
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier:ViewControllerIds.DeleteAccount) as? DeleteAccountViewController
        vcObj?.callDismissedAction = viewController?.presentDeleteAccountAction()
//        let navDelete = UINavigationController(rootViewController: vcObj!)
        self.viewController?.present(vcObj!, animated: true, completion: nil)
    }
}

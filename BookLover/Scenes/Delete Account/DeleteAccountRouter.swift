
import UIKit

@objc protocol DeleteAccountRoutingLogic
{
    func navigateToLogin()
   // func navigateToAccountSetting(isverify : Bool, dismiss: Bool)
}

protocol DeleteAccountDataPassing
{
  var dataStore: DeleteAccountDataStore? { get }
}

class DeleteAccountRouter: NSObject, DeleteAccountRoutingLogic, DeleteAccountDataPassing
{
  weak var viewController: DeleteAccountViewController?
  var dataStore: DeleteAccountDataStore?
    
    func navigateToLogin() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier:ViewControllerIds.Login) as? LoginViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
}

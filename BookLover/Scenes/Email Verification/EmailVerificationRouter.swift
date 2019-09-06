
import UIKit

@objc protocol EmailVerificationRoutingLogic
{
    func navigateToAccountSetting(isverify : Bool)
}

protocol EmailVerificationDataPassing
{
  var dataStore: EmailVerificationDataStore? { get }
}

class EmailVerificationRouter: NSObject, EmailVerificationRoutingLogic, EmailVerificationDataPassing
{
  weak var viewController: EmailVerificationViewController?
  var dataStore: EmailVerificationDataStore?
    
    func navigateToAccountSetting(isverify : Bool){

        for controller in (self.viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: AccountSettingViewController.self) {
                var destinationDS = (controller as! AccountSettingViewController).router!.dataStore!
                passDataToShowOrder(source: dataStore!, destination: &destinationDS,isverify:isverify)
                self.viewController?.navigationController?.popToViewController(controller, animated: false)
                break
            }
        }
    }
  // MARK: Passing data
  
    func passDataToShowOrder(source: EmailVerificationDataStore, destination: inout AccountSettingDataStore,isverify:Bool)
    {
        destination.Isverify = isverify
    }
}

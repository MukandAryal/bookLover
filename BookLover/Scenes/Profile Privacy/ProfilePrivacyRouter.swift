

import UIKit

@objc protocol ProfilePrivacyRoutingLogic
{
    func navigateToPopUpScene(title:String)
}

protocol ProfilePrivacyDataPassing
{
  var dataStore: ProfilePrivacyDataStore? { get }
}

class ProfilePrivacyRouter: NSObject, ProfilePrivacyRoutingLogic, ProfilePrivacyDataPassing
{
  weak var viewController: ProfilePrivacyViewController?
  var dataStore: ProfilePrivacyDataStore?
    func navigateToPopUpScene(title:String) {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.PrivacyPopUp) as? PrivacyPopUpViewController
        vcObj?.titleStr = title
        
        self.viewController?.present(vcObj!, animated: true, completion: nil)
    }
}

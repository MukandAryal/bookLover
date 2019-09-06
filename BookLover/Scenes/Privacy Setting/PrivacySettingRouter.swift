

import UIKit

@objc protocol PrivacySettingRoutingLogic
{
   func navigateToProfilePrivacyScene()
   func navigateToReviewsPrivacyScene()
   func navigateToOthersPrivacyScene()
}

protocol PrivacySettingDataPassing
{
  var dataStore: PrivacySettingDataStore? { get }
}

class PrivacySettingRouter: NSObject, PrivacySettingRoutingLogic, PrivacySettingDataPassing
{
    weak var viewController: PrivacySettingViewController?
    var dataStore: PrivacySettingDataStore?
    
    
    func navigateToProfilePrivacyScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ProfilePrivacy) as? ProfilePrivacyViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    func navigateToReviewsPrivacyScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ReviewsPrivacy) as? ReviewsPrivacyViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    func navigateToOthersPrivacyScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.OtherPrivacy) as? OtherPriViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
}

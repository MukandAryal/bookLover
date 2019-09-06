

import UIKit

@objc protocol SettingsRoutingLogic
{
  func navigateToPrivacySettingScene()
  func navigateToAccountSettingScene()
    func navigateToCompleteProfileScene()

}

protocol SettingsDataPassing
{
  var dataStore: SettingsDataStore? { get }

}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing
{
  weak var viewController: SettingsViewController?
  var dataStore: SettingsDataStore?
  
  // MARK: Routing
    
    func navigateToCompleteProfileScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.CompleteProfile) as? CompleteProfileViewController
        var destinationDS = vcObj?.router!.dataStore!
        passDataToCompleteProfile(source: dataStore!, destination: &destinationDS!, isSetting:true)
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    
    func passDataToCompleteProfile(source: SettingsDataStore, destination: inout CompleteProfileDataStore, isSetting: Bool)
    {
        destination.isSetting = isSetting
    }
    
    func navigateToPrivacySettingScene() {
        let storyboard: UIStoryboard = UIStoryboard(name: settingStoryboard, bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.PrivacySetting) as? PrivacySettingViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    func navigateToAccountSettingScene() {
        let storyboard: UIStoryboard = UIStoryboard(name: settingStoryboard, bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.AccountSetting) as? AccountSettingViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
}

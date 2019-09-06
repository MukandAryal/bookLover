/** This is custom made class which contains methods written in swift to instantiate the RM Alert Controller third party library which is in objective-C
 URL :- https://github.com/donileo/RMessage
 */

import Foundation
import UIKit

class CustomAlertController: NSObject {
    
    static let sharedInstance = CustomAlertController()
    
    private override init() {}
        
    /**
     This function will show the alert of user defined type with no callBack.
     
     ### Usage Example: ###
     ````
     CustomAlertController.sharedInstance.showAlert(title:"title", subTitle:"subTitle", type:RMessageType.success/error etc.)
     ````
     */
    
    func showAlert(subTitle:String?, type:RMessageType) {
        RMessage.showNotification(withTitle: localizedTextFor(key: GeneralText.appName.rawValue), subtitle: subTitle, type: type, customTypeName: nil, duration: 1.5, callback: nil)
    }
    
    
    /**
     This function will show the error alert
     
     ### Usage Example: ###
     ````
     CustomAlertController.sharedInstance.showErrorAlert(error:"error string")
     ````
     */
    
    func showErrorAlert(error:String) {
        showAlert(subTitle: error, type: .error)
    }
    
    func showSuccessAlert(success:String) {
        showAlert(subTitle: success, type: .success)
    }
    
    func showComingSoonAlert() {
        
        showAlert(subTitle: localizedTextFor(key: GeneralText.comingSoon.rawValue), type: .warning )
        
//         RMessage.showNotification(withTitle: localizedTextFor(key: GeneralText.comingSoon.rawValue), subtitle: localizedTextFor(key: GeneralText.appName.rawValue), iconImage: nil, type: RMessageType.normal, customTypeName: nil, duration: 1.5, callback: nil, buttonTitle: nil, buttonCallback: nil, at: RMessagePosition.bottom, canBeDismissedByUser: true)
    }
    
    
    func showLoginFirstAlert() {
        
        showAlert(subTitle: localizedTextFor(key: GeneralValidations.LoginFirstKey.rawValue), type: .error)
        
//        RMessage.showNotification(withTitle: localizedTextFor(key: GeneralValidations.LoginFirstKey.rawValue), subtitle: localizedTextFor(key: GeneralText.appName.rawValue), iconImage: nil, type: RMessageType.normal, customTypeName: nil, duration: 1.5, callback: nil, buttonTitle: nil, buttonCallback: nil, at: RMessagePosition.bottom, canBeDismissedByUser: true)
    }
    
    func showInternetAlert() {
        showAlert(subTitle: localizedTextFor(key: ValidationsText.kNetworkError.rawValue), type: .error)
//        RMessage.showNotification(withTitle: localizedTextFor(key: ValidationsText.kNetworkError.rawValue), subtitle: localizedTextFor(key: GeneralText.appName.rawValue), iconImage: nil, type: RMessageType.normal, customTypeName: nil, duration: 1.5, callback: nil, buttonTitle: nil, buttonCallback: nil, at: RMessagePosition.bottom, canBeDismissedByUser: true)
    }
    
}

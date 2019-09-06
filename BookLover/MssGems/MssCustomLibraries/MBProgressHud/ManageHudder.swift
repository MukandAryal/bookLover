/** This is custom made class which contains methods written in swift to instantiate the progress hudder third party library which is in objective-C
 URL :- https://github.com/jdg/MBProgressHUD
 */

import Foundation
import UIKit

class ManageHudder: NSObject {
    
    static let sharedInstance = ManageHudder()
    
    var alertWindow:UIWindow?
    
    private override init() {}
    
    /**
     This function will show the activity indicator in centre of the screen.
     
     ### Usage Example: ###
     ````
     ManageHudder.sharedInstance.startActivityIndicator()
     ````
     */
    
    func startActivityIndicator() {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = (appDelegateObj.window?.windowLevel)! + 1
        alertWindow?.makeKeyAndVisible()
        
        let sourceView = alertWindow?.rootViewController!.view!
        let spinnerActivity = MBProgressHUD.showAdded(to: sourceView!, animated: true)
        spinnerActivity.label.text = nil
        spinnerActivity.detailsLabel.text = nil
    }
    
    
    /**
     This function will hide the currently showing activity indicator.
     
     ### Usage Example: ###
     ````
     ManageHudder.sharedInstance.stopActivityIndicator()
     ````
     */
    
    func stopActivityIndicator() {
        if let sourceView = alertWindow?.rootViewController!.view! {
            MBProgressHUD.hide(for: sourceView, animated: true)
            alertWindow?.resignKey()
        }
        alertWindow = nil
        appDelegateObj.window?.makeKeyAndVisible()
    }
    
}


import UIKit

@objc protocol ResetPasswordRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func navigateToAccountSetting(isverify : Bool)

}

protocol ResetPasswordDataPassing
{
  var dataStore: ResetPasswordDataStore? { get }
}

class ResetPasswordRouter: NSObject, ResetPasswordRoutingLogic, ResetPasswordDataPassing
{
  weak var viewController: ResetPasswordViewController?
  var dataStore: ResetPasswordDataStore?
  
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
    
    func passDataToShowOrder(source: ResetPasswordDataStore, destination: inout AccountSettingDataStore, isverify:Bool?)
    {
        destination.Isverify = isverify
    }
    
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ResetPasswordViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ResetPasswordDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}

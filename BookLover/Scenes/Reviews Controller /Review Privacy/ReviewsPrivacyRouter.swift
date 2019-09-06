
import UIKit

@objc protocol ReviewsPrivacyRoutingLogic
{
    func navigateToPopUpScene(title:String)
}

protocol ReviewsPrivacyDataPassing
{
    var dataStore: ReviewsPrivacyDataStore? { get }
}

class ReviewsPrivacyRouter: NSObject, ReviewsPrivacyRoutingLogic, ReviewsPrivacyDataPassing
{
    weak var viewController: ReviewsPrivacyViewController?
    var dataStore: ReviewsPrivacyDataStore?
    func navigateToPopUpScene(title: String) {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier:ViewControllerIds.PrivacyPopUp) as? PrivacyPopUpViewController
        vcObj?.titleStr = title
        self.viewController?.present(vcObj!, animated: true, completion: nil)
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
    
    //func navigateToSomewhere(source: ReviewsPrivacyViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: ReviewsPrivacyDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}

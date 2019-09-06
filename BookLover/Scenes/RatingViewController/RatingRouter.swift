
import UIKit

@objc protocol RatingRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol RatingDataPassing
{
  var dataStore: RatingDataStore? { get }
}

class RatingRouter: NSObject, RatingRoutingLogic, RatingDataPassing
{
  weak var viewController: RatingViewController?
  var dataStore: RatingDataStore?
  
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
  
  //func navigateToSomewhere(source: RatingViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: RatingDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}



import UIKit

@objc protocol ShelfTypeRoutingLogic
{
    func navigateToBookShelves(withData: [String:Any])
    func navigateToAllReview(bookId: String)
    func navigateToBookDetail(bookId: String)
}

protocol ShelfTypeDataPassing
{
  var dataStore: ShelfTypeDataStore? { get }
}

class ShelfTypeRouter: NSObject, ShelfTypeRoutingLogic, ShelfTypeDataPassing
{
  weak var viewController: ShelfTypeViewController?
  var dataStore: ShelfTypeDataStore?
  
  // MARK: Routing
    

    func navigateToBookShelves(withData: [String : Any]) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.BookShelves) as! BookShelvesViewController
        destinationVC.dictShelfData = withData
        let navCountry = UINavigationController(rootViewController: destinationVC)
        self.viewController?.present(navCountry, animated: true, completion: nil)
    }

    
    func navigateToAllReview(bookId: String) {
        
//        var isFound : Bool = false
//        for controller in (viewController?.navigationController?.viewControllers)! {
//            if controller.isKind(of: ShowAllReviewViewController.self) {
//                var ds = (controller as! ShowAllReviewViewController).router?.dataStore
//                passDataToAllReview(bookId: bookId, destinationDS: &ds!)
//                viewController?.navigationController?.popToViewController(controller, animated: false)
//                isFound = true
//                break
//            }
//        }
//
//        if isFound == false {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ShowAllReview) as! ShowAllReviewViewController
            var ds = destinationVC.router?.dataStore
            passDataToAllReview(bookId: bookId, destinationDS: &ds!)
            pushToAllReview(source: viewController!, destination: destinationVC)
       // }
    }
    
    func pushToAllReview(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToAllReview(bookId: String, destinationDS: inout ShowAllReviewDataStore)
    {
        destinationDS.bookId = bookId
    }
    
    
    func navigateToBookDetail(bookId: String) {
        
//        var isFound : Bool = false
//        for controller in (viewController?.navigationController?.viewControllers)! {
//            if controller.isKind(of: ShowAllReviewViewController.self) {
//                var ds = (controller as! ShowAllReviewViewController).router?.dataStore
//                passDataToAllReview(bookId: bookId, destinationDS: &ds!)
//                viewController?.navigationController?.popToViewController(controller, animated: false)
//                isFound = true
//                break
//            }
//        }
//
//        if isFound == false {
        
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.BookDetail) as! BookDetailViewController
            var ds = destinationVC.router?.dataStore
            passDataToBookDetail(bookId: bookId, destinationDS: &ds!)
            pushToBookDetail(source: viewController!, destination: destinationVC)
       // }
    }
    
    func pushToBookDetail(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToBookDetail(bookId: String, destinationDS: inout BookDetailDataStore)
    {
        destinationDS.bookId = bookId
    }
  
}

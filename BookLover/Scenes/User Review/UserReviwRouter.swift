
import UIKit

@objc protocol UserReviwRoutingLogic
{
    func navigateToUserProfile(withId: String)

    func navigateBack()
     func navigateToAddComment(reviewId: String)
    func routeToRating(rating:Double, description:String, bookId:String)
}

protocol UserReviwDataPassing
{
  var dataStore: UserReviwDataStore? { get }
}

class UserReviwRouter: NSObject, UserReviwRoutingLogic, UserReviwDataPassing
{
  weak var viewController: UserReviwViewController?
  var dataStore: UserReviwDataStore?
  
  // MARK: Routing
//
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    
    func navigateToAddComment(reviewId: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.AddComment) as! AddCommentViewController
        var ds = destinationVC.router?.dataStore
        passDataToAddComment(reviewId: reviewId, destinationDS: &ds!)
        pushToAddComment(source: viewController!, destination: destinationVC)
    }

    func pushToAddComment(source: UIViewController, destination: UIViewController) {
        let addComment = UINavigationController(rootViewController: destination)
        source.present(addComment, animated: true, completion: nil)
//        source.navigationController?.pushViewController(destination, animated: true)
    }

    func passDataToAddComment(reviewId: String, destinationDS: inout AddCommentDataStore)
    {
        destinationDS.reviewId = reviewId
    }
    
    func navigateToUserProfile(withId: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.UserProfile) as! ProfileViewController
        var ds = destinationVC.router?.dataStore
        passDataToProfile(withId: withId, destinationDS: &ds!)
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func passDataToProfile(withId: String, destinationDS: inout ProfileDataStore)
    {
        destinationDS.userId = withId
        destinationDS.isFromSideMenu = false
    }
    
    func routeToRating(rating: Double, description: String, bookId:String) {
        
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Rating) as! RatingViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToRating(source: dataStore!, destination: &destinationDS, rating: rating, description: description, bookId:bookId)
        navigateToRating(source: viewController!, destination: destinationVC)
    }
    
    
    // MARK: Navigation
    
    func navigateToRating(source: UserReviwViewController, destination: RatingViewController)
    {
        source.show(destination, sender: nil)
    }
    
    
    // MARK: Passing data
    func passDataToRating(source: UserReviwDataStore, destination: inout RatingDataStore, rating: Double, description: String, bookId:String)
    {
        destination.description = description
        destination.rating = rating
        destination.bookId = bookId
        destination.isRatingEdit = true
    }
 
}

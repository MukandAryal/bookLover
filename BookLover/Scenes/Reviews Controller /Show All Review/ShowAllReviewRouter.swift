
import UIKit

@objc protocol ShowAllReviewRoutingLogic
{
    func navigateToUserReview(reviewId: String)
   // func navigateToUserProfile(withData: ProfileInfo.Data)
    func navigateToUserProfile(withId: String)
    func navigateToRatingView(bookId: String)
}

protocol ShowAllReviewDataPassing
{
  var dataStore: ShowAllReviewDataStore? { get }
}

class ShowAllReviewRouter: NSObject, ShowAllReviewRoutingLogic, ShowAllReviewDataPassing
{
    
    weak var viewController: ShowAllReviewViewController?
    var dataStore: ShowAllReviewDataStore?
    
    
    func navigateToUserReview(reviewId: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.UserReview) as! UserReviwViewController
        var ds = destinationVC.router?.dataStore
        passDataToUserReview(reviewId: reviewId, destinationDS: &ds!)
        pushToUserReview(source: viewController!, destination: destinationVC)
    }
    
    func pushToUserReview(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToUserReview(reviewId: String, destinationDS: inout UserReviwDataStore)
    {
        destinationDS.reviewId = reviewId
    }
    
    
    func navigateToRatingView(bookId: String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.Rating) as! RatingViewController
        var ds = destinationVC.router?.dataStore
        passDataToRatingView(bookId: bookId, destinationDS: &ds!)
        pushToRatingView(source: viewController!, destination: destinationVC)
    }
    
    func pushToRatingView(source: UIViewController, destination: UIViewController) {
        let toRating = UINavigationController(rootViewController: destination)
        source.present(toRating, animated: true, completion: nil)
    }
    
    func passDataToRatingView(bookId: String, destinationDS: inout RatingDataStore)
    {
        destinationDS.bookId = bookId
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
    
    
//    func navigateToUserProfile(withData: ProfileInfo.Data) {
//        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.UserProfile) as! ProfileViewController
//        var ds = destinationVC.router?.dataStore
//        passDataToProfile(withData: withData, destinationDS: &ds!)
//        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
//    }
//
//    func passDataToProfile(withData: ProfileInfo.Data, destinationDS: inout ProfileDataStore)
//    {
//        destinationDS.readerData = withData
//    }
    
//    func pushToProfile(source: UIViewController, destination: UIViewController) {
//        source.navigationController?.pushViewController(destination, animated: true)
//    }
//    
//    func passDataToProfile(reviewId: String, destinationDS: inout UserReviwDataStore)
//    {
//        destinationDS.reviewId = reviewId
//    }
    
}

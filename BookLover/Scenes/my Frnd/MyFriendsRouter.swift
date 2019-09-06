

import UIKit

@objc protocol MyFriendsRoutingLogic
{
    func navigateToAddFriendScene()
    func navigateToUserProfile(withId: String)
}

protocol MyFriendsDataPassing
{
    var dataStore: MyFriendsDataStore? { get }
    
}

class MyFriendsRouter: NSObject, MyFriendsRoutingLogic, MyFriendsDataPassing
{

    weak var viewController: MyFriendsViewController?
    var dataStore: MyFriendsDataStore?
    func navigateToAddFriendScene() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.AddFriend) as? AddFriendViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
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
}

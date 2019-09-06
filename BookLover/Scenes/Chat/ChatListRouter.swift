
import UIKit

@objc protocol ChatListRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func navigateToChatScene(from_user_id:Int,userName:String,userImage:String)
    func navigateToUserProfile(withId: String)
}

protocol ChatListDataPassing
{
  var dataStore: ChatListDataStore? { get }
}

class ChatListRouter: NSObject, ChatListRoutingLogic, ChatListDataPassing
{
    
  weak var viewController: ChatListViewController?
  var dataStore: ChatListDataStore?
    
    func navigateToChatScene(from_user_id:Int,userName:String,userImage:String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ChatController) as! ChatViewController
        var ds = destinationVC.router?.dataStore
        passDataToChatView(FromUserId: from_user_id,userName:userName,userImage:userImage, destinationDS: &ds!)
        pushToBookDetail(source: viewController!, destination: destinationVC)
    }
    
    func pushToBookDetail(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToChatView(FromUserId: Int,userName:String,userImage:String, destinationDS: inout ChatDataStore)
    {
        destinationDS.from_user_id = FromUserId
        destinationDS.userName = userName
        destinationDS.userImage = userImage
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

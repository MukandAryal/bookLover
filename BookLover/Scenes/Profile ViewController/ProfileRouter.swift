
import UIKit

@objc protocol ProfileRoutingLogic
{
     func navigateToShelfType(shelfStatus: Int, title:String, userId:String)
     func navigateToMyFriends()
     func navigateToChatScene(from_user_id:Int,userName:String,userImage:String)
     func navigateToBookDetail()
}

protocol ProfileDataPassing
{
    var dataStore: ProfileDataStore? { get }
}

class ProfileRouter: NSObject, ProfileRoutingLogic, ProfileDataPassing
{
    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?
    
    
    func navigateToShelfType(shelfStatus: Int, title:String, userId:String) {
        let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.ShelfType) as! ShelfTypeViewController
        var ds = destinationVC.router?.dataStore
        passDataToShelfType(shelfStatus: shelfStatus, title:title, userId:userId, destinationDS: &ds!)
        pushToShelfType(source: viewController!, destination: destinationVC)
    }
    
    func navigateToMyFriends() {
        let vcObj = self.viewController?.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.MyFriends) as? MyFriendsViewController
        self.viewController?.navigationController?.pushViewController(vcObj!, animated: true)
    }
    
    
    func pushToShelfType(source: UIViewController, destination: UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }

    func passDataToShelfType(shelfStatus: Int, title:String, userId:String, destinationDS: inout ShelfTypeDataStore)
    {
        destinationDS.shelfStatus = shelfStatus
        destinationDS.navTitle = title
        destinationDS.userId = userId
    }
    
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
    
    func navigateToBookDetail() {
        
        for controller in (viewController?.navigationController?.viewControllers)! {
            if controller.isKind(of: BookDetailViewController.self) {
                viewController?.navigationController?.popToViewController(controller, animated: false)
                break
            }
        }
    }

}

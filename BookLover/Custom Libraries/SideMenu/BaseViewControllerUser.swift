/** This is customized version of the side menu for the user module.
 The original one is available at
 URL :- http://ashishkakkad.com/2015/09/create-your-own-slider-menu-drawer-in-swift/
 */
import UIKit

class BaseViewControllerUser: UIViewController, SlideMenuDelegate {
    
    var isMenuOpened: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        switch(index){
            
        case 0:
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.Home)
            break
            
        case 1:
            // notification scene
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.Notification)
           // CustomAlertController.sharedInstance.showComingSoonAlert()
            break
            
        case 2:
            // chat scene
         self.openViewControllerBasedOnIdentifier(ViewControllerIds.Chat)
          //  CustomAlertController.sharedInstance.showComingSoonAlert()

            break
            
        case 3:
            // mybooks scene
           // CustomAlertController.sharedInstance.showComingSoonAlert()
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.shelves)

            break
           
        case 4:
            // friends scene
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.MyFriends)
//            CustomAlertController.sharedInstance.showComingSoonAlert()

            break
            
        case 5:
            // settings scene
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.Settings)
            break
            
        case 6:
            // profile/login scene
            self.openViewControllerBasedOnIdentifier(ViewControllerIds.UserProfile)
            //CustomAlertController.sharedInstance.showComingSoonAlert()

            break
            
        default:
            break
        }
    }
    
    
   
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        
        //let storyboard: UIStoryboard = UIStoryboard(name: storyboardId, bundle: nil)
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
        }
        else {
            if destViewController.isKind(of: ProfileViewController.self) {
                var ds = (destViewController as! ProfileViewController).router?.dataStore
                passDataToProfile(
                    withId: CommonFunctions.sharedInstance.getUserId(),
                    destinationDS: &ds!)
            }
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func passDataToProfile(withId: String, destinationDS: inout ProfileDataStore)
    {
        destinationDS.userId = withId
        destinationDS.isFromSideMenu = true
    }
    
    func addSlideMenuButton(){
   
        let customBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(BaseViewControllerUser.onSlideMenuButtonPressed))
        customBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = customBarButton
        
        addSwipeToRightGesture()
    }
    
    func addSwipeToRightGesture() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizerDirection.right {
                onSlideMenuButtonPressed()
            } else {
                return
            }
//            switch swipeGesture.direction {
//            case UISwipeGestureRecognizerDirection.right:
//                print("Swiped right")
//            case UISwipeGestureRecognizerDirection.down:
//                print("Swiped down")
//            case UISwipeGestureRecognizerDirection.left:
//                print("Swiped left")
//            case UISwipeGestureRecognizerDirection.up:
//                print("Swiped up")
//            default:
//                break
//            }
        }
    }
    
    @objc func onSlideMenuButtonPressed() {
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
            if self.childViewControllers.count > 0 {
                
                // To Hide Menu If it already there
                self.slideMenuItemSelectedAtIndex(-1);
                
//                button.tag = 0;
                let vcObj = self.childViewControllers[0]
                let viewMenuBack : UIView = view.subviews.last!
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    var frameMenu : CGRect = viewMenuBack.frame
                    frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                    viewMenuBack.frame = frameMenu
                    viewMenuBack.layoutIfNeeded()
                    viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
                    vcObj.removeFromParentViewController()
                })
                return
            }
            
//            button.isEnabled = false
//            button.tag = 10
        
        
          //  menuVC.btnMenu = button
            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChildViewController(menuVC)
            menuVC.view.layoutIfNeeded()
            
            
            menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            // printToConsole(item: menuVC.view.frame)
            
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                
                if menuVC.view.frame.size.height > UIScreen.main.bounds.size.height + 49 {
                    menuVC.view.frame.size.height = UIScreen.main.bounds.size.height + 49
                }
//                button.isEnabled = true
//                userDefault.set(true, forKey: userDefualtKeys.userLoggedIn.rawValue)

            }){ (bool) in
                // printToConsole(item: menuVC.view.frame)
            }
//
        }
        
    
    func showLogoutAlert() {
        
        let alertController = PMAlertController(textForegroundColor:UIColor.darkGray, viewBackgroundColor: UIColor.white, title: localizedTextFor(key: "UserSideMenuText.logoutAlert.rawValue"), description: "", image: nil, style: .alert)
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.no.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(PMAlertAction(title: localizedTextFor(key: GeneralText.yes.rawValue), style: .default, action: {
            alertController.dismiss(animated: true, completion: nil)

          //  self.hitLogoutApi()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    /**
    func hitLogoutApi() {
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.userModule.logout + "/" + getUserData(._id), httpMethod: .put, headers:ApiHeaders.sharedInstance.headerWithAuth()) { (response) in
            if response.code == 200 {
                
                // updating user log in status in user default
                userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
                
                // updating user data in user default
                userDefault.removeObject(forKey: userDefualtKeys.UserObject.rawValue)
                
                // Clears app delegate user object dictioary
                appDelegateObj.userDataDictionary.removeAllObjects()
                self.moveToLoginScreen()
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    */
    
    func moveToLoginScreen() {
        let initialNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllersIds.InitialControllerID")
        appDelegateObj.window?.rootViewController = initialNavigationController
        appDelegateObj.window?.makeKeyAndVisible()
        
    }
}

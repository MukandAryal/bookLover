
import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController {
    
    //  Array to display menu options
    @IBOutlet var tblMenuOptions : UITableView!
    
    //  Transparent button to hide menu
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    
    @IBOutlet var tblHeaderView: UIView!
    
    @IBOutlet weak var lblUserName: UILabelFontSize!
    @IBOutlet weak var lblBooks: UILabelFontSize!
    @IBOutlet weak var btnUserImg: UIButton!
    
    
    //  Array containing menu options
    var arrayMenuOptions = [
        ["title":localizedTextFor(key: SceneTitleText.HomeSceneTitle.rawValue), "icon":"home_icon"],
        ["title":localizedTextFor(key: SceneTitleText.NotificationsSceneTitle.rawValue), "icon":"bell_side_menu"],
        ["title":localizedTextFor(key: SceneTitleText.ChatSceneTitle.rawValue), "icon":"chat_side_menu"],
        ["title":localizedTextFor(key: SceneTitleText.MyBooksSceneTitle.rawValue), "icon":"my_book"],
        ["title":localizedTextFor(key: SceneTitleText.FriendsSceneTitle.rawValue), "icon":"frind"],
        ["title":localizedTextFor(key: SceneTitleText.SettingsSceneTitle.rawValue), "icon":"setting"],
        ["title":localizedTextFor(key: SceneTitleText.MyProfileSceneTitle.rawValue), "icon":"my_profile"]
    ]
    
    
    
    //  Menu button which was tapped to display the menu
    var btnMenu : UIButton!
    
    //  Delegate of the MenuVC
    var delegate : SlideMenuDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipe()
    }
    
    
    
    func addSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.closeSideMenu))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func closeSideMenu() {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.tabBarController?.setTabBarVisible(visible: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.removeFromParentViewController()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            var strImg : String = ""
            if appDelegateObj.userData["user_image"] != nil, let _ = appDelegateObj.userData["user_image"] as? String {
                strImg = Configurator.imageBaseUrl + (appDelegateObj.userData["user_image"] as! String)
            }
            
            var strName : NSMutableString = ""
            if appDelegateObj.userData["firstname"] != nil, let _ = appDelegateObj.userData["firstname"] as? String {
                strName.append((appDelegateObj.userData["firstname"] as? String)!)
                strName.append(" ")
            }
            
            if appDelegateObj.userData["lastname"] != nil, let _ = appDelegateObj.userData["lastname"] as? String {
                strName.append((appDelegateObj.userData["lastname"] as? String)!)
            }
            
            if appDelegateObj.userData["totalBooks"] != nil, let _ = appDelegateObj.userData["totalBooks"] as? Int  {
                lblBooks.isHidden = false
                lblBooks.text = localizedTextFor(key: HomeSceneText.NumberOfBooksTitle.rawValue) + ": \(appDelegateObj.userData["totalBooks"] as! Int)"
            } else {
                lblBooks.isHidden = true
            }
            
            if strName.length > 0 {
                lblUserName.text = String(strName)
            }
            
            btnUserImg.layer.cornerRadius = btnUserImg.frame.size.height/2.0
            btnUserImg.sd_setImage(with: URL(string: strImg), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
            btnUserImg.layer.borderWidth = 2.0
            btnUserImg.layer.borderColor = UIColor.white.cgColor
            btnUserImg.clipsToBounds = true
            
            tblMenuOptions.tableHeaderView = tblHeaderView
            
        } else {
            tblMenuOptions.tableHeaderView = UIView()
            
        }
        //        tblMenuOptions.tableHeaderView?.isHidden = true
        tblMenuOptions.tableFooterView = UIView()
        
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        
        let object = arrayMenuOptions[indexPath.row]
        cell.setData(dict:object as [String : AnyObject], indexPath:indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
}


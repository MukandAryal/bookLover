

import UIKit

protocol SettingsDisplayLogic: class
{
}

class SettingsViewController: BaseViewControllerUser, SettingsDisplayLogic
{
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /////////////////////////////////////////////////////////////////////
    // MARK: Class Helper --
    @IBOutlet weak var accountSettingBtn: UIButtonFontSize!
    @IBOutlet weak var profileSettingBtn: UIButtonFontSize!
    @IBOutlet weak var privacySettingBtn: UIButtonFontSize!
    @IBOutlet weak var logoutBtn: UIButtonFontSize!
    
     // MARK: viewDidLoad --
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
     // MARK: viewWillAppear --
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
      // MARK: Class Helper --
    func setUpInterface() {
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.SettingsSceneTitle.rawValue))
        addSlideMenuButton()

        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
        
        accountSettingBtn.setTitle(localizedTextFor(key: SettingsModuleText.AccountSettingsTitle.rawValue), for: .normal)
        profileSettingBtn.setTitle(localizedTextFor(key:SettingsModuleText.ProfileSettingsTitle.rawValue), for:.normal)
        privacySettingBtn.setTitle(localizedTextFor(key:SettingsModuleText.PrivacySettingsTitle.rawValue), for:.normal)
        logoutBtn.setTitle(localizedTextFor(key:SettingsModuleText.LogoutTitle.rawValue), for:.normal)
        logoutBtn.layer.cornerRadius  = logoutBtn.frame.size.height/2.0
    }
    
      // MARK: Button Action--
    
    @IBAction func actionPrivacyBtn(_ sender: UIButton) {
        router?.navigateToPrivacySettingScene()
    }
    
    @IBAction func actionAccountSettingBtn(_ sender: UIButton) {
       router?.navigateToAccountSettingScene()
    }
    
    @IBAction func actionProfileSetting(_ sender: Any) {
        router?.navigateToCompleteProfileScene()
    }
    
    @IBAction func actionLogOutBtn(_ sender: UIButton) {
        // router?.navigateToAccountSettingScene()
//        userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
//        userDefault.set(false, forKey: userDefualtKeys.userProfileCompleted.rawValue)
//
//        // updating user data in user default
//        userDefault.removeObject(forKey: userDefualtKeys.userObject.rawValue)
//
//        // Clears app delegate user object dictioary
//        appDelegateObj.userData.removeAllObjects()
        CommonFunctions.sharedInstance.removeUserData()
        CommonFunctions.sharedInstance.navigateToHome(nav: self.navigationController!)
    }
}

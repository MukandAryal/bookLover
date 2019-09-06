
import UIKit

protocol ProfilePrivacyDisplayLogic: class
{
}

class ProfilePrivacyViewController: UIViewController, ProfilePrivacyDisplayLogic
{
    var interactor: ProfilePrivacyBusinessLogic?
    var router: (NSObjectProtocol & ProfilePrivacyRoutingLogic & ProfilePrivacyDataPassing)?
    
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
        let interactor = ProfilePrivacyInteractor()
        let presenter = ProfilePrivacyPresenter()
        let router = ProfilePrivacyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /////////////////////////////////////////////////////////
     // MARK: Outlet --
    @IBOutlet weak var profilePictureBtn: UIButtonFontSize!
    @IBOutlet weak var profilePrivacyLbl: UILabelFontSize!
    @IBOutlet weak var emailAddressBtn: UIButtonFontSize!
    @IBOutlet weak var emailPrivacyLbl: UILabelFontSize!
    @IBOutlet weak var ageBtn: UIButtonFontSize!
    @IBOutlet weak var agePrivacyLbl: UILabelFontSize!
    @IBOutlet weak var genderBtn: UIButtonFontSize!
    @IBOutlet weak var genderPrivacyLbl: UILabelFontSize!
    @IBOutlet weak var lblProfilePicture: UILabelFontSize!
    @IBOutlet weak var lblAgePrivacy: UILabelFontSize!
    @IBOutlet weak var lblEmailAddress: UILabelFontSize!
    @IBOutlet weak var lblGenderPrivacy: UILabelFontSize!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var imgAge: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!

    
     // MARK: viewDidLoad--
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: viewWillAppear--
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    func setUpInterface() {
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.ProfileSettingsTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self); profilePictureBtn.setTitle(localizedTextFor(key:ProfilePrivacyText.profilePicture.rawValue), for:.normal)
        emailAddressBtn.setTitle(localizedTextFor(key:ProfilePrivacyText.addressEmail.rawValue), for:.normal)
        ageBtn.setTitle(localizedTextFor(key:ProfilePrivacyText.age.rawValue), for:.normal)
        genderBtn.setTitle(localizedTextFor(key:ProfilePrivacyText.gender.rawValue), for:.normal)
        
        let userData = appDelegateObj.userData
        var privacyArr = userData["Privacies"] as! [[String:Any]]
        var privacyData = privacyArr[0]
        
        let profilePic = privacyData["profile_pic"] as? Int
        if profilePic == 0 {
            imgProfile.image = UIImage(named: "public")
            lblProfilePicture.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if profilePic == 1 {
            imgProfile.image = UIImage(named: "friend")
            lblProfilePicture.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgProfile.image = UIImage(named: "only_me")
            lblProfilePicture.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }
        
        let emailAddress = privacyData["email"] as? Int
        if emailAddress == 0 {
            imgEmail.image = UIImage(named: "public")
            lblEmailAddress.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if emailAddress == 1 {
            imgEmail.image = UIImage(named: "friend")
            lblEmailAddress.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgEmail.image = UIImage(named: "only_me")
            lblEmailAddress.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }
        
        let age = privacyData["age"] as? Int
        if age == 0 {
            imgAge.image = UIImage(named: "public")
            lblAgePrivacy.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if age == 1 {
            imgAge.image = UIImage(named: "friend")
            lblAgePrivacy.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgAge.image = UIImage(named: "only_me")
            lblAgePrivacy.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }
        
        let gender = privacyData["gender"] as? Int
        if gender == 0 {
            imgGender.image = UIImage(named: "public")
            lblGenderPrivacy.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if gender == 1 {
            imgGender.image = UIImage(named: "friend")
            lblGenderPrivacy.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgGender.image = UIImage(named: "only_me")
            lblGenderPrivacy.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }
    }
     // MARK: viewWillDisappear--
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
     // MARK: Button Action--
    @IBAction func actionProfilePicture(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key: ProfilePrivacyText.profilePicture.rawValue))
    }
    @IBAction func actionEmailAddress(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key: ProfilePrivacyText.addressEmail.rawValue))
    }
    @IBAction func actionAge(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key: ProfilePrivacyText.age.rawValue))
    }
    @IBAction func actionGender(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key: ProfilePrivacyText.gender.rawValue))
    }
}

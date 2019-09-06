
import UIKit

protocol PrivacySettingDisplayLogic: class
{
}

class PrivacySettingViewController: UIViewController, PrivacySettingDisplayLogic
{
    var interactor: PrivacySettingBusinessLogic?
    var router: (NSObjectProtocol & PrivacySettingRoutingLogic & PrivacySettingDataPassing)?
    
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
        let interactor = PrivacySettingInteractor()
        let presenter = PrivacySettingPresenter()
        let router = PrivacySettingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    ////////////////////////////////////////////////////
    
    @IBOutlet weak var profilePrivacyBtn: UIButtonFontSize!
    @IBOutlet weak var reviewsPrivacyBtn: UIButtonFontSize!
    @IBOutlet weak var othersBtn: UIButtonFontSize!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    func setUpInterface() {
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.PrivacySettingsTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        profilePrivacyBtn.setTitle(localizedTextFor(key: PrivacySettingText.profilePrivacy.rawValue), for: .normal)
        reviewsPrivacyBtn.setTitle(localizedTextFor(key:PrivacySettingText.reviewsPrivacy.rawValue), for:.normal)
       
        othersBtn.setTitle(localizedTextFor(key:PrivacySettingText.other.rawValue), for:.normal)
        
    }
    @IBAction func actionProfilePrivacyBtn(_ sender: UIButton) {
        router?.navigateToProfilePrivacyScene()
    }
    @IBAction func actionReviewsPrivacyBtn(_ sender: UIButton) {
        router?.navigateToReviewsPrivacyScene()
    }
    @IBAction func actionOtherBtn(_ sender: UIButton) {
        router?.navigateToOthersPrivacyScene()
    }
    
}



import UIKit

protocol ReviewsPrivacyDisplayLogic: class
{
    
}

class ReviewsPrivacyViewController: UIViewController, ReviewsPrivacyDisplayLogic
{
    var interactor: ReviewsPrivacyBusinessLogic?
    var router: (NSObjectProtocol & ReviewsPrivacyRoutingLogic & ReviewsPrivacyDataPassing)?
    
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
        let interactor = ReviewsPrivacyInteractor()
        let presenter = ReviewsPrivacyPresenter()
        let router = ReviewsPrivacyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    /////////////////////////////////////////////////////////////
    // MARK: Outlet ---
    @IBOutlet weak var followMeBtn: UIButtonFontSize!
    @IBOutlet weak var followMePrivacyLbl: UILabelFontSize!
    @IBOutlet weak var commentBtn: UIButtonFontSize!
    @IBOutlet weak var commentPrivacyLbl: UILabelFontSize!
    @IBOutlet weak var lblComment: UILabelFontSize!
    @IBOutlet weak var lblFollow: UILabelFontSize!

    
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var imgFollowMe: UIImageView!
     // MARK: viewDidLoad ---
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
      // MARK: viewWillAppear ---
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
     // MARK: Class Helper ---
    func setUpInterface() {
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.ReviewsSettingTitile.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        lblFollow.text = localizedTextFor(key: ReviewsPrivacyText.whoCanfollowMe.rawValue)
        lblComment.text = localizedTextFor(key: ReviewsPrivacyText.whoCanfollowMe.rawValue)
//        followMeBtn.setTitle(localizedTextFor(key: ReviewsPrivacyText.whoCanComment.rawValue), for: .normal)
//        commentBtn.setTitle(localizedTextFor(key:ReviewsPrivacyText.whoCanComment.rawValue), for:.normal)
        
        let userData = appDelegateObj.userData
        var privacyArr = userData["Privacies"] as! [[String:Any]]
        var privacyData = privacyArr[0]
        
        let comment = privacyData["comment"] as? Int
        if comment == 0 {
            imgComment.image = UIImage(named: "public")
            commentPrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if comment == 1 {
            imgComment.image = UIImage(named: "friend")
            commentPrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgComment.image = UIImage(named: "only_me")
            commentPrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }

        
        let follow = privacyData["follow"] as? Int
        if follow == 0 {
            imgFollowMe.image = UIImage(named: "public")
            followMePrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue)
        }else if follow == 1 {
            imgFollowMe.image = UIImage(named: "friend")
            followMePrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue)
        }else{
            imgFollowMe.image = UIImage(named: "only_me")
            followMePrivacyLbl.text = localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue)
        }
    }
    
   
    @IBAction func actionWhoCanFollowMe(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key:ReviewsPrivacyText.whoCanfollowMe.rawValue))
    }
    @IBAction func actionWhoCanComment(_ sender: Any) {
        router?.navigateToPopUpScene(title:localizedTextFor(key:ReviewsPrivacyText.whoCanComment.rawValue))
    }
}

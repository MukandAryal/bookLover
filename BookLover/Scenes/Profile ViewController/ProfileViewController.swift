

import UIKit

typealias BlockUserCompletion = (_ isComplete: Bool?, _ isBlock: Bool?) -> ()

protocol ProfileDisplayLogic: class
{
    func displayUserProfileInfo(viewModel:Profile.ViewModel)
    func displayReportUserInfo(viewModel:Profile.ViewModel.ReportUser)
    func displayBlockUserInfo(viewModel:Profile.ViewModel.BlockUser)
    func displaySendRequsetInfo(viewModel:Profile.ViewModel.ReportUser)
    func displayCancelRequsetInfo(viewModel:Profile.ViewModel.ReportUser)
    var strFriendObjId : String? { get set }
}

class ProfileViewController: BaseViewControllerUser, ProfileDisplayLogic
{
    var interactor: ProfileBusinessLogic?
    var router: (NSObjectProtocol & ProfileRoutingLogic & ProfileDataPassing)?
    
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
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: Outlet Helper --
    
    @IBOutlet weak var btnMyFriends: UIButtonFontSize!
    @IBOutlet weak var btnFavouriteBooks: UIButtonFontSize!
    @IBOutlet weak var lblReadCount: UILabelFontSize!
    @IBOutlet weak var lblWantToReadCount: UILabelFontSize!
    @IBOutlet weak var lblCurrentlyReadingCount: UILabelFontSize!
    @IBOutlet weak var lblUserName: UILabelFontSize!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var lblHeadingAgeGender: UILabelFontSize!
    @IBOutlet weak var lblAgeGender: UILabelFontSize!
    @IBOutlet weak var lblHeadingLocation: UILabelFontSize!
    @IBOutlet weak var lblLocation: UILabelFontSize!
    @IBOutlet weak var lblHeadingLastActive: UILabelFontSize!
    @IBOutlet weak var lblLastActive: UILabelFontSize!
    @IBOutlet weak var lblHeadingJoined: UILabelFontSize!
    @IBOutlet weak var lblJoind: UILabelFontSize!
    @IBOutlet weak var btnChat: UIButtonFontSize!
    @IBOutlet weak var btnSendRequest: UIButtonFontSize!
    @IBOutlet weak var lblBookShelves: UILabelFontSize!
    @IBOutlet weak var lblRead: UILabelFontSize!
    @IBOutlet weak var lblWantToRead: UILabelFontSize!
    @IBOutlet weak var lblCurrentlyReading: UILabelFontSize!
    @IBOutlet weak var lblFavTitle: UILabelFontSize!
    @IBOutlet weak var lblFavCount: UILabelFontSize!
    @IBOutlet weak var lblBooks: UILabelFontSize!
    @IBOutlet weak var txtViewAboutDescription: UITextView!
    @IBOutlet weak var chatFriendStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var myFriendTopSpace: NSLayoutConstraint!
    @IBOutlet weak var favoriteTopSpace: NSLayoutConstraint!
    @IBOutlet weak var myBookArrow: UIImageView!
    @IBOutlet weak var favView: UIView!
    
    var strFriendObjId : String?
    var isReaderProfile: Bool?
    var userInfoData = Profile.ViewModel.UserInfo()
    var fromUserId : Int?
    var userImage : String? = ""
    var UserfullName : String?
    // MARK: viewDidLoad Helper --
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .always
        }
    }
    
    // MARK: viewWillAppear Helper --
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isReaderProfile = false
        setUpNavigation()
        setUpInterface()
        requestUserProfile()
    }
    
    // MARK: setUpInterface Helper --
    
    func setUpInterface() {
        
        btnMyFriends.layer.cornerRadius = 5
        btnMyFriends.clipsToBounds = true
        lblFavCount.layer.masksToBounds = true
        lblFavCount.layer.cornerRadius = lblFavCount.frame.size.height/2.0
        lblReadCount.layer.masksToBounds = true
        lblReadCount.layer.cornerRadius = lblReadCount.frame.size.height/2
        lblWantToReadCount.layer.masksToBounds = true
        lblWantToReadCount.layer.cornerRadius = lblWantToReadCount.frame.size.height/2
        lblCurrentlyReadingCount.layer.masksToBounds = true
        lblCurrentlyReadingCount.layer.cornerRadius = lblCurrentlyReadingCount.frame.size.height/2
        
        lblHeadingAgeGender.text = localizedTextFor(key:UserProfileText.AgeGender.rawValue) + " : "
        lblHeadingLocation.text = localizedTextFor(key: UserProfileText.Location.rawValue) + " : "
        lblHeadingJoined.text = localizedTextFor(key: UserProfileText.Joined.rawValue) + " : "
        lblHeadingLastActive.text = localizedTextFor(key: UserProfileText.LastActive.rawValue).uppercased() + " : "
        btnChat.setTitle(localizedTextFor(key:UserProfileText.Chat.rawValue), for:.normal)
        btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.SendRequest.rawValue), for:.normal)
        
        btnMyFriends.setTitle(localizedTextFor(key:UserProfileText.MyFriends.rawValue), for:.normal)
        lblBookShelves.text = localizedTextFor(key:UserProfileText.BookShelves.rawValue)
        lblRead.text = localizedTextFor(key:UserProfileText.Read.rawValue)
        lblWantToRead.text = localizedTextFor(key:UserProfileText.WantToRead.rawValue)
        lblCurrentlyReading.text = localizedTextFor(key:UserProfileText.CurrentlyReading.rawValue)
        lblFavTitle.text = localizedTextFor(key:UserProfileText.FavouriteBooks.rawValue)
        
        if router?.dataStore?.isFromSideMenu == true {
            myProfileUISetup()
        } else {

            if CommonFunctions.sharedInstance.isUserLoggedIn() {
                if CommonFunctions.sharedInstance.getUserId() == router?.dataStore?.userId {
                    myProfileUISetup()
                    return
                }
            }
            readerProfileSetUp()
        }
    }
    
    
    func setUpNavigation() {
        
        if router?.dataStore?.isFromSideMenu == true {

            CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.MyProfileSceneTitle.rawValue))
            addSlideMenuButton()

        } else {
            
            CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
            if CommonFunctions.sharedInstance.isUserLoggedIn() {
                if CommonFunctions.sharedInstance.getUserId() == router?.dataStore?.userId {
                    CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.MyProfileSceneTitle.rawValue))
                    return
                }
            }

            CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ReaderProfileSceneTitle.rawValue))
            setRightBarButton()
            isReaderProfile = true
        }
    }
    
    func setRightBarButton() {
        
        let btnMenu = UIButtonFontSize(type: .custom)
        btnMenu.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btnMenu.setImage(UIImage(named: "thee_dot"), for: UIControlState())
        btnMenu.tintColor = UIColor.white
        //        btnMenu.backgroundColor = appThemeColor
        btnMenu.addTarget(self, action: #selector(actionBlockMenu(_:)), for: UIControlEvents.touchUpInside)
        let menu = UIBarButtonItem(customView: btnMenu)
        
        self.navigationItem.setRightBarButtonItems([menu], animated: false)
    }
    
    
    func myProfileUISetup() {
        
        chatFriendStackView.isHidden = true
        stackHeight.constant = 0
        myFriendTopSpace.constant = 20
        favoriteTopSpace.constant = 95
        btnMyFriends.isHidden = false
        myBookArrow.isHidden = false
    }
    
    
    func readerProfileSetUp()  {
        btnMyFriends.isHidden = true
        myBookArrow.isHidden = true
    }
    
    func performPopUpDismissAction() -> BlockUserCompletion {
        
        return { [unowned self] isComplete, isBlock  in
            
            if isComplete == true {
                if isBlock! {
                    self.interactor?.blockUserApi(withId:"\((self.userInfoData.id)!)")
                } else {
                    self.interactor?.reportUserApi(withId:"\((self.userInfoData.id)!)")
                }
            }else{
                return
            }
        }
    }
    
    // MARK: Request Helper --
    
    
    
    func requestUserProfile(){
        interactor?.getUserProfileApi()
    }
    
    // MARK: Display Helper --
    func displayUserProfileInfo(viewModel: Profile.ViewModel) {
        
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        }else{
            userInfoData = viewModel.userData!
            fromUserId = userInfoData.id
            if userInfoData.user_image != nil {
                userImage = userInfoData.user_image
            }
            let fullName : NSMutableString = ""

            if userInfoData.firstname != nil, let _ = userInfoData.firstname {
                fullName.append((userInfoData.firstname)!)
                fullName.append(" ")
            }
            if userInfoData.lastname != nil, let _ = userInfoData.lastname {
                fullName.append((userInfoData.lastname)!)
            }
            
            if fullName == "" {
                lblUserName.text = "- -"
            }else {
                lblUserName.text = fullName as String
            }
            UserfullName = fullName as String
            displayData()
        }
        //interactor?.getReaderData()
    }
    
    func displayReportUserInfo(viewModel:Profile.ViewModel.ReportUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(
                error: viewModel.error!)
        }else{
            CustomAlertController.sharedInstance.showSuccessAlert(
                success: viewModel.success!)
        }
    }
    
    func displayBlockUserInfo(viewModel:Profile.ViewModel.BlockUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(
                error: viewModel.error!)
        }else{
            CustomAlertController.sharedInstance.showSuccessAlert(
                success: viewModel.success!)
            router?.navigateToBookDetail()
        }
    }
    
    func displaySendRequsetInfo(viewModel:Profile.ViewModel.ReportUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.CancelRequest.rawValue), for:.normal)
        }
        
    }
    
    func displayCancelRequsetInfo(viewModel:Profile.ViewModel.ReportUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.SendRequest.rawValue), for:.normal)
        }
    }
    
    // MARK: DisplayData Helper --
    
    func displayData(){
        
        let fullName : NSMutableString = ""
        
        if userInfoData.firstname != nil, let _ = userInfoData.firstname {
            fullName.append((userInfoData.firstname)!)
            fullName.append(" ")
        }
        if userInfoData.lastname != nil, let _ = userInfoData.lastname {
            fullName.append((userInfoData.lastname)!)
        }
        
        if fullName == "" {
            lblUserName.text = "- -"
        }else {
            lblUserName.text = fullName as String
        }
        
        let ageGender : NSMutableString = ""
        if userInfoData.age != nil, let _ = userInfoData.age {
            ageGender.append("\(userInfoData.age!),")
            ageGender.append(" ")
        }
        
        if userInfoData.gender != nil, let _ = userInfoData.gender {
            ageGender.append((userInfoData.gender)!)
        }
        
        if ageGender == ""{
            lblAgeGender.text = "- -"
        }else {
            lblAgeGender.text = ageGender as String
        }
        
        let location : NSMutableString = ""
        if userInfoData.state != nil, let _ = userInfoData.state {
            location.append("\(userInfoData.state!),")
            location.append(" ")
        }
        
        if userInfoData.country != nil, let _ = userInfoData.country {
            location.append((userInfoData.country)!)
        }
        
        if location == "" {
            lblLocation.text = "- -"
        }else {
            lblLocation.text = location as String
        }
        
        
        lblLastActive.text = "--"
        if userInfoData.last_seen != nil, let _ = userInfoData.last_seen {
            if userInfoData.viewLastSeen == 1 {
                let str = userInfoData.last_seen!.components(separatedBy: "T")[0]
                let date = CommonFunctions.sharedInstance.generateDate(str, format: .format11)
                let strDate = CommonFunctions.sharedInstance.generateDateString(date, format: .format6)
                lblLastActive.text = strDate
            }
        }
        
        if userInfoData.readBooks != nil {
            lblReadCount.text = ("\(userInfoData.readBooks!)")
        }else{
            lblReadCount.text = "- -"
        }
        
        if userInfoData.pendingBooks != nil{
            lblWantToReadCount.text = ("\(userInfoData.pendingBooks!)")
        }else{
            lblWantToReadCount.text = "- -"
        }
        
        if userInfoData.created_at != nil, let _ = userInfoData.created_at {
            let str = userInfoData.created_at!.components(separatedBy: "T")[0]
            let date = CommonFunctions.sharedInstance.generateDate(str, format: .format11)
            let strDate = CommonFunctions.sharedInstance.generateDateString(date, format: .format6)
            lblJoind.text = strDate
        } else {
            lblJoind.text = "- -"
        }
        
        if userInfoData.readingBooks != nil{
            lblCurrentlyReadingCount.text = ("\(userInfoData.readingBooks!)")
        }else{
            lblCurrentlyReadingCount.text = "- -"
        }
        
        if userInfoData.about != nil{
            txtViewAboutDescription.text =  localizedTextFor(key:UserProfileText.About.rawValue) + " : " + (userInfoData.about!)
        }else{
            txtViewAboutDescription.text =  localizedTextFor(key:UserProfileText.About.rawValue) + " : -"
        }
        
        if userInfoData.viewmessage == 0 {
            
        }
        
        btnUserProfile.layer.cornerRadius = btnUserProfile.frame.size.height/2.0
        btnUserProfile.clipsToBounds = true
        btnUserProfile.setImage(UIImage(named: "profile_photo"), for: .normal)

        if userInfoData.user_image != nil, let _ = userInfoData.user_image {
            if userInfoData.viewprofile_pic == 0 {
                btnUserProfile.sd_setImage(with: URL(string: Configurator.imageBaseUrl + userInfoData.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
            }
        }
        
        
        if (userInfoData.favouriteBooks?.count)! > 0 {
            
            let strBooks : NSMutableString = ""
            for obj in userInfoData.favouriteBooks! {
                strBooks.append("\((obj.name)!),")
            }
            
            var strIm = strBooks as String
            if strBooks.length>0 {
                strIm.removeLast()
            }
            lblFavCount.isHidden = false
            lblFavCount.text = "\((userInfoData.favBooks)!)"
            lblBooks.text = strIm
        } else {
            lblFavCount.isHidden = true
            lblBooks.text = ""
        }
        
        if isReaderProfile! {
            setReaderPrivacy()
        }
    }
    
    func setReaderPrivacy() {
        
        if userInfoData.viewage != 0 && userInfoData.viewgender != 0 {
            lblAgeGender.text = "- -"
        } else if userInfoData.viewage != 0 && userInfoData.viewgender == 0 {
            lblAgeGender.text = userInfoData.gender
        } else if userInfoData.viewage == 0 && userInfoData.viewgender != 0 {
            lblAgeGender.text = "\(userInfoData.age!)"
        }
        
        if userInfoData.viewfollow != 0 && userInfoData.viewmessage == 0 {
            chatFriendStackView.isHidden = true
            stackHeight.constant = 0
            favoriteTopSpace.constant = 20
        }else {
            chatFriendStackView.isHidden = false
            stackHeight.constant = 55
            favoriteTopSpace.constant = 75
            if userInfoData.viewmessage == 0 {
                btnChat.isHidden = true
            } else {
                btnChat.isHidden = false
            }
            
            if userInfoData.viewfollow != 0 {
                btnSendRequest.isHidden = true
            } else {
                btnSendRequest.isHidden = false
            }
            
//            if userInfoData.viewmessage != 0 {
//                btnChat.isHidden = true
//                btnSendRequest.isHidden = false
//            } else if userInfoData.viewfollow != 0 {
//                btnChat.isHidden = false
//                btnSendRequest.isHidden = true
//            }
        }
        
        if let _ = userInfoData.friendData {
            if userInfoData.friendData?.status == 0 {
                btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.CancelRequest.rawValue), for:.normal)
            } else if userInfoData.friendData?.status == 1 {
                btnSendRequest.setTitle(localizedTextFor(key: SceneTitleText.FriendsSceneTitle.rawValue), for:.normal)
            } else if userInfoData.friendData?.status == 3 {
                btnSendRequest.setTitle("Blocked", for:.normal)
            } else {
                btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.SendRequest.rawValue), for:.normal)
            }
        } else {
            btnSendRequest.setTitle(localizedTextFor(key:UserProfileText.SendRequest.rawValue), for:.normal)
        }
    }
    
    // MARK: Button Action Helper --
    
    @objc func actionBlockMenu(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            if let usrId = userInfoData.id {
                
                var blockStatus: Bool = false
                if (userInfoData.friendData?.status) != nil && userInfoData.friendData?.status == 3 {
                    blockStatus = true
                }
                popToBlockPopUp(
                    onButton: sender,
                    withFriendId: "\(usrId)",
                    isBocked: blockStatus,
                    atCompletion: performPopUpDismissAction())
            }
           
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @IBAction func actionChat(_ sender: Any) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            if fromUserId != nil {
                router?.navigateToChatScene(from_user_id:fromUserId!,userName:UserfullName!,userImage:userImage!)
            }
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @IBAction func actionSendRequest(_ sender: Any) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            if let _ = userInfoData.id {
                
                if btnSendRequest.titleLabel?.text == localizedTextFor(key:UserProfileText.SendRequest.rawValue) {
                    
                    interactor?.sendFriendRequestAPI()
                    
                } else  if btnSendRequest.titleLabel?.text == localizedTextFor(key: SceneTitleText.FriendsSceneTitle.rawValue) || btnSendRequest.titleLabel?.text == localizedTextFor(key:UserProfileText.CancelRequest.rawValue) {
                    
                    var strFriendId : String = ""
                    if userInfoData.friendData != nil, let _ = userInfoData.friendData?.id {
                        strFriendId = "\((userInfoData.friendData?.id!)!)"
                    } else {
                        strFriendId = strFriendObjId!
                    }
                    let req = Profile.Request.CancelRequest(id: strFriendId, status: 2)
                    interactor?.cancelFriendRequestAPI(request: req)
                    
                } else {
                    return
                }
            }
            
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @IBAction func actionMyFriend(_ sender: Any) {
       router?.navigateToMyFriends()
    }
    
    @IBAction func actionFavouriteBooks(_ sender: Any) {
        if let _ = userInfoData.id {
            if userInfoData.favBooks! > 0 {
                router?.navigateToShelfType(shelfStatus: 3, title: lblFavTitle.text!, userId:"\((userInfoData.id)!)")
            }
        }
    }
    
    @IBAction func actionReadBook(_ sender: Any) {
        if let _ = userInfoData.id {
            if userInfoData.readBooks! > 0 {
                router?.navigateToShelfType(shelfStatus: 2, title: lblRead.text!, userId:"\((userInfoData.id)!)")
            }
        }
    }
    
    @IBAction func actionWantToRead(_ sender: Any) {
         if let _ = userInfoData.id {
            if userInfoData.pendingBooks! > 0 {
                router?.navigateToShelfType(shelfStatus: 0, title: lblWantToRead.text!, userId:"\((userInfoData.id)!)")
            }
        }
    }
    
    @IBAction func actionCurrentlyReading(_ sender: Any) {
        if let _ = userInfoData.id {
            if userInfoData.readingBooks! > 0 {
                router?.navigateToShelfType(shelfStatus: 1, title: lblCurrentlyReading.text!, userId:"\((userInfoData.id)!)")
            }
        }
    }
}

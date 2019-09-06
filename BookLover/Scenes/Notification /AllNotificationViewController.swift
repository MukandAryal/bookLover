
import UIKit

protocol AllNotificationDisplayLogic: class
{
    func displayGetNotifocation(viewModel: AllNotification.ViewModel)
    func displayGetFriendRequest(viewModel:AllNotification.friendRequest)
    func displayAcceptRequsetInfo(viewModel:AllNotification.friendRequest.ReportUser, atIndex: Int)
    func displayDeclineRequsetInfo(viewModel:AllNotification.friendRequest.ReportUser, atIndex: Int)
    func displayRedirectNotification(viewModel:AllNotification.friendRequest.ReportUser)
    func displayRedirectOtherNotification(viewModel:AllNotification.friendRequest.ReportUser)
}

class AllNotificationViewController: BaseViewControllerUser, AllNotificationDisplayLogic
{
    var interactor: AllNotificationBusinessLogic?
    var router: (NSObjectProtocol & AllNotificationRoutingLogic & AllNotificationDataPassing)?
    
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
        let interactor = AllNotificationInteractor()
        let presenter = AllNotificationPresenter()
        let router = AllNotificationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
   
    ///////////////////////////////////////////////////////////////
    
    @IBOutlet weak var tabSwipeFrameView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var lblNoNotificationFound: UILabelFontSize!
    var arrGetNotification = [AllNotification.ViewModel.userInfo]()
    var arrGetFriendRequest = [AllNotification.friendRequest.friendRequestUserInfo]()
    var segmentedControl = HMSegmentedControl()
    var  bookId : Int?
    var reviewId : Int?
    
    //MARK: -- Life Cycle --
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        notificationTableView.tableFooterView = UIView()
        requestTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUIDesign()
        getAllNotification()
    }
    
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = appBackGroundColor
        
    }
    
    func setupSwipeScrollView() {
        self.mainScrollView.delegate = self;
    }
    
    func setupSegment() {
        let viewWidth = Int(self.view.frame.size.width)
        
        // Tying up the segmented control to a scroll view
        self.segmentedControl = HMSegmentedControl(frame: tabSwipeFrameView.frame)
        
        self.segmentedControl.sectionTitles = [localizedTextFor(key: SceneTitleText.NotificationTabTitle.rawValue), localizedTextFor(key: SceneTitleText.FriendRequestTabTitle.rawValue)]
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.backgroundColor = appBackGroundColor
        let colorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        self.segmentedControl.titleTextAttributes = colorAttribute
        
        let selectedColorAttribute = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.segmentedControl.selectedTitleTextAttributes = selectedColorAttribute
        self.segmentedControl.selectionIndicatorColor = appThemeColor
        self.segmentedControl.selectionStyle = .fullWidthStripe
        self.segmentedControl.selectionIndicatorLocation = .down
        
        weak var weakSelf = self
        segmentedControl.indexChangeBlock = {(_ index: Int) -> Void in
            weakSelf!.mainScrollView.scrollRectToVisible(CGRect(x: (viewWidth * index), y: 0, width: viewWidth, height: Int(self.mainScrollView.bounds.size.height)), animated: true)
        }
        self.view.addSubview(self.segmentedControl)
    }
    
    //MARK: -- getAllNotification --
    func getAllNotification(){
        interactor?.allNotification()
    }
    
    func getFriendRequest(){
        interactor?.allFriendRequest()
    }
    
    //MARK: -- Class Helper --
    func setUIDesign() {
        
        addSlideMenuButton()

        lblNoNotificationFound.isHidden = true
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.NotificationsSceneTitle.rawValue))
        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
    }
    
    
    
    //MARK: -- DisplayGetNotifocation --
    func displayGetNotifocation(viewModel: AllNotification.ViewModel) {
        if viewModel.error != nil {
            setupSwipeScrollView()
            setupSegment()
        }else{
            arrGetNotification = viewModel.notificationInfo!
            notificationTableView.reloadData()
        }
        setupSwipeScrollView()
        setupSegment()
        
    }
    
    //MARK: -- DisplayGetFriendRequest --
    func displayGetFriendRequest(viewModel: AllNotification.friendRequest) {
        if viewModel.error != nil {
            // aleart
        }else{
            arrGetFriendRequest = viewModel.frindRequestInfo!
            requestTableView.reloadData()
        }
    }
    
    //MARK: -- DisplayAcceptRequset --
    
    func displayAcceptRequsetInfo(viewModel: AllNotification.friendRequest.ReportUser, atIndex: Int) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            arrGetFriendRequest.remove(at: atIndex)
            requestTableView.reloadData()
        }
    }
    
    //MARK: -- DisplayDeclineRequset --
    
    func displayDeclineRequsetInfo(viewModel: AllNotification.friendRequest.ReportUser, atIndex: Int) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            arrGetFriendRequest.remove(at: atIndex)
            requestTableView.reloadData()
        }
    }
    
    //MARK: -- DisplayRedirectNotification --
    func displayRedirectNotification(viewModel: AllNotification.friendRequest.ReportUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            self.router?.navigateToBookDetail(bookId: bookId!)
        }
    }
    
    func displayRedirectOtherNotification(viewModel: AllNotification.friendRequest.ReportUser) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            router?.navigateToUserReview(reviewId: "\(reviewId!)")
        }
    }
    
    // MARK: Cell Button Action
    @objc func actionaddButton(_ sender: UIButton) {
        
        let reqAddFriend = AllNotification.Request.acceptRequest(id: "\((arrGetFriendRequest[sender.tag].frnd?.id)!)",index: sender.tag)
        interactor?.acceptFriendRequestApi(request:reqAddFriend)
    }
    
    @objc func actionCancalButton(_ sender: UIButton) {
        let reqCancalFriend = AllNotification.Request.declineRequest(id: "\((arrGetFriendRequest[sender.tag].frnd?.id)!)",index: sender.tag)
        interactor?.declineFriendRequestApi(request:reqCancalFriend)
        
    }
    
    @objc func actionFriendRequestUserProfile(_ sender: UIButton) {
        router?.navigateToUserProfile(withId: "\((arrGetFriendRequest[sender.tag].id)!)")
    }
    
    @objc func actionNotificationViewUserProfile(_ sender: UIButton) {
        router?.navigateToUserProfile(withId: "\((arrGetNotification[sender.tag].nuser_id)!)")
    }
}

extension AllNotificationViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == notificationTableView {
            if arrGetNotification.count > 0{
                
                return arrGetNotification.count
                
            }else{
                
                return 1
            }
        }
        else {
            if arrGetFriendRequest.count > 0{
                
                return arrGetFriendRequest.count
                
            }else{
                return 1
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationTableView {
            if arrGetNotification.count > 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AllNotificationTableViewCell

                let notificationData = arrGetNotification[indexPath.row]
                let notificationMsg : NSMutableString = ""
                if notificationData.message != nil, let _ = notificationData.message {
                    notificationMsg.append((notificationData.message)!)
                    notificationMsg.append(" ")
                }
                if notificationMsg == ""{
                    cell.notificationLbl.text = " "
                }else {
                    cell.notificationLbl.text = notificationMsg as String
                }
                
                cell.userProfileBtn.setImage(UIImage(named: "profile_photo"), for: .normal)

                if notificationData.nuseruser_image != nil, let _ = notificationData.nuseruser_image {
                    
                    if notificationData.Privacies?.profile_pic == 0 {
                     cell.userProfileBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + notificationData.nuseruser_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                    }
                }
                
                if notificationData.is_read == 0{
                    cell.userProfileBtn.layer.borderColor = appThemeColor.cgColor
                } else {
                    cell.userProfileBtn.layer.borderColor = UIColor.white.cgColor
                }
                
                let TimestampStr =  notificationData.created
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let messageDate = inputFormatter.date(from: TimestampStr!)
                cell.notificatioTimeLbl.text = timeStamp.sharedInstance.timeAgoSinceDate(messageDate!, currentDate: Date(), numericDates: true)
                
                cell.userProfileBtn.tag = indexPath.row
                cell.userProfileBtn.addTarget(self, action: #selector(actionNotificationViewUserProfile(_:)), for: .touchUpInside)
                 return cell
            } else  {
                notificationTableView.register(UINib(nibName: ViewControllerIds.NoDataTableViewCell, bundle: nil), forCellReuseIdentifier: ViewControllerIds.NoDataTableViewCell)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.NoDataTableViewCell, for: indexPath) as! NoDataTableViewCell
                
                cell.lblNoData.text = localizedTextFor(key: NoDataFoundScene.NoNotificationFound.rawValue)
                cell.lblNoData.textColor = UIColor.white
                return cell
            }
           
        }else {
            if arrGetFriendRequest.count > 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AllNotificationRequestTableViewCell

                
                let friendRequestData = arrGetFriendRequest[indexPath.row]
                let fullName : NSMutableString = ""
                if friendRequestData.firstname != nil, let _ = friendRequestData.firstname {
                    fullName.append((friendRequestData.firstname)!)
                    fullName.append(" ")
                }
                if friendRequestData.lastname != nil, let _ = friendRequestData.lastname {
                    fullName.append((friendRequestData.lastname)!)
                }
                if fullName == ""{
                    cell.userNameLabel.text = " "
                }else {
                    cell.userNameLabel.text = fullName as String
                }
                let ageGender : NSMutableString = ""
                if friendRequestData.age != nil, let _ = friendRequestData.age {
                    ageGender.append("\(friendRequestData.age!),")
                    ageGender.append(" ")
                }
                if friendRequestData.gender != nil, let _ = friendRequestData.gender {
                    ageGender.append((friendRequestData.gender)!)
                }
                if ageGender == ""{
                    cell.userAgeLabel.text = " "
                }else {
                    cell.userAgeLabel.text = ageGender as String
                }
                
                let location : NSMutableString = ""
                if friendRequestData.state != nil, let _ = friendRequestData.state {
                    location.append("\(friendRequestData.state!),")
                    location.append(" ")
                }
                if friendRequestData.country != nil, let _ = friendRequestData.country {
                    location.append((friendRequestData.country)!)
                }
                if location == ""{
                    cell.userLocationLabel.text = " "
                }else {
                    cell.userLocationLabel.text = location as String
                }
                
                cell.userProfileBtn.setImage(UIImage(named: "profile_photo"), for: .normal)

                if friendRequestData.user_image != nil, let _ = friendRequestData.user_image {
                    
                    if friendRequestData.Privacies?.profile_pic == 0 {
                        cell.userProfileBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + friendRequestData.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                    }
                }
                
                cell.userProfileBtn.tag = indexPath.row
                cell.userProfileBtn.addTarget(self, action: #selector(actionFriendRequestUserProfile(_:)), for: .touchUpInside)
                
                if Int(CommonFunctions.sharedInstance.getUserId()) == friendRequestData.frnd?.user_id {
                    cell.acceptBtn?.isHidden = true
                    cell.declineBtn?.setTitle(localizedTextFor(key: AddFriendRequestReadersText.Cancel.rawValue).uppercased(), for: .normal)
                } else {
                    cell.declineBtn?.setTitle(localizedTextFor(key: NotificationFriendRequestText.decline.rawValue), for: .normal)
                    cell.acceptBtn?.isHidden = false
                    cell.acceptBtn?.tag = indexPath.row
                    cell.acceptBtn?.addTarget(self, action: #selector(actionaddButton(_:)), for: .touchUpInside)
                }
                
                cell.declineBtn?.tag = indexPath.row
                cell.declineBtn?.addTarget(self, action: #selector(actionCancalButton(_:)), for: .touchUpInside)
                
                if friendRequestData.categary != nil {
                    cell.arrCategory = friendRequestData.categary
                    cell.notificationCollectionView.reloadData()
                }
                
                return cell

            } else  {
                requestTableView.register(UINib(nibName: ViewControllerIds.NoDataTableViewCell, bundle: nil), forCellReuseIdentifier: ViewControllerIds.NoDataTableViewCell)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.NoDataTableViewCell, for: indexPath) as! NoDataTableViewCell
                
                cell.lblNoData.text = localizedTextFor(key: NoDataFoundScene.NoNotificationFound.rawValue)
                cell.lblNoData.textColor = UIColor.white
                return cell
            }
            //cell.vcObj = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notificationTableView {
            if arrGetNotification.count > 0 {
                let notificationData = arrGetNotification[indexPath.row]
                 let type = notificationData.type
                if type == "shareBook" {
                    bookId = notificationData.book_id
                    let shareNotification = AllNotification.Request.shareNotification(id: notificationData.id!, type: notificationData.type, bookId : notificationData.book_id!)
                    interactor?.shareBookNotificationRedirect(request: shareNotification)
                }
                else{
                    reviewId = notificationData.review_id
                    let otherNotification = AllNotification.Request.otherNotification(review_id:notificationData.review_id, type: notificationData.type, id:"\(notificationData.id!)")
                    interactor?.otherBookNotificationRedirect(request:otherNotification)
                }
            }
            
        }
    }
}

extension AllNotificationViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            let pageWidth = scrollView.frame.size.width
            let page = scrollView.contentOffset.x / pageWidth
            self.segmentedControl.selectedSegmentIndex = Int(page)
            if Int(page) == 0 {
                getAllNotification()
            }else{
                getFriendRequest()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            let pageWidth = scrollView.frame.size.width
            let page = scrollView.contentOffset.x / pageWidth
            printToConsole(item: page)
            self.segmentedControl.selectedSegmentIndex = Int(page)
            if Int(page) == 0 {
                getAllNotification()
            }else{
                getFriendRequest()
            }
        }
    }
    
}

extension AllNotificationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: mainScrollView) ?? false || touch.view?.isDescendant(of: notificationTableView) ?? false {
            return false
        }
        return true
    }
}

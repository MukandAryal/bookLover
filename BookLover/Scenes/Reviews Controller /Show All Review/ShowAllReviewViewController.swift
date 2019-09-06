
import UIKit

protocol ShowAllReviewDisplayLogic: class
{
    func displayAllReview(viewModel : ShowAllReview.ViewModel)
    func displayLikeUnlikeReview(viewModel : ShowAllReview.LikeUnlikeModel, atIndex: Int)
}

class ShowAllReviewViewController: UIViewController, ShowAllReviewDisplayLogic
{
    var interactor: ShowAllReviewBusinessLogic?
    var router: (NSObjectProtocol & ShowAllReviewRoutingLogic & ShowAllReviewDataPassing)?
    var pageNumber: Int = 1
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
        let interactor = ShowAllReviewInteractor()
        let presenter = ShowAllReviewPresenter()
        let router = ShowAllReviewRouter()
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
    
    //////////////////////////////////////////////////////////////
    //MARK:- Outlet --
    private var lastContentOffset: CGFloat = 0
    var arrReviewAll = [ShowAllReview.ViewModel.Review]()
    @IBOutlet weak var tblReviewAll: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUIDesign()
        allReviewRequest()
    }
    
    
    //MARK:- Requset Helper --

    func allReviewRequest(){
        interactor?.getAllReviewData()
    }
    
    
    //MARK:- Response Helper --

    func displayAllReview(viewModel: ShowAllReview.ViewModel) {
        
        if viewModel.error != nil {
            // aleart
        }else{
            arrReviewAll = viewModel.reviewAllList!
            tblReviewAll .reloadData()
        }
    }
    
    func displayLikeUnlikeReview(viewModel : ShowAllReview.LikeUnlikeModel, atIndex: Int) {

        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
//            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            interactor?.getAllReviewData()
        }
    }

    //MARK:- Button Action --

    @objc func actionWriteReview (sender: UIButtonFontSize) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            router?.navigateToRatingView(bookId: (router?.dataStore?.bookId)!)
        }else{
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @objc func actionLikeUnlikeReview (sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            var isLike : Bool = false
            if arrReviewAll[sender.tag].is_like == true {
                isLike = false
            } else {
                isLike = true
            }
            
            let likeReq = ShowAllReview.Request.LikeUnlike.init(
                reviewId: "\(arrReviewAll[sender.tag].id!)",
                isLike: isLike,
                index: sender.tag)
            interactor?.likeUnlikeReview(request: likeReq)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @objc func actionUserProfile(_ sender: UIButton) {
        
//        if CommonFunctions.sharedInstance.isUserLoggedIn() {
//            if CommonFunctions.sharedInstance.getUserId() == "\((arrReviewAll[sender.tag].user?.id)!)" {
//                CustomAlertController.sharedInstance.showComingSoonAlert()
//                return
//            }
//        }
        router?.navigateToUserProfile(withId: "\((arrReviewAll[sender.tag].user?.id)!)")
    }
    
    @objc func actionViewUserReview (sender: UIButton) {
        if  arrReviewAll.count > 0  {
            router?.navigateToUserReview(reviewId: "\((arrReviewAll[sender.tag].id)!)")
        }
    }
    
    
    //MARK:- Class Helper --

    func setUpUIDesign() {
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ReviewSceneTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        //setRightBarButton()
        
//        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
//        private let refreshControl = UIRefreshControl()
//
//        if #available(iOS 11.0, *) {
//            tblSearchBook.refreshControl = refreshControl
//        } else {
//            tblSearchBook.addSubview(refreshControl)
//        }
//
//        refreshControl.tintColor = appThemeColor
//        refreshControl.addTarget(self, action: #selector(refreshEventsData(_:)), for: .valueChanged)
       
        tblReviewAll.tableFooterView = UIView()
    }
    
    func setRightBarButton() {
        
        let btnWriteReview = UIButtonFontSize(type: .custom)
        btnWriteReview.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btnWriteReview.layer.cornerRadius = 5.0
        btnWriteReview.setAttributedTitle(NSAttributedString(string: localizedTextFor(key: BookDetailText.WriteReviewTitle.rawValue), attributes: [NSAttributedStringKey.font: UIFont(name: "Futura", size: 13)!]), for: .normal)
        btnWriteReview.setTitleColor(UIColor.darkText, for: .normal)
        btnWriteReview.titleLabel?.font = UIFont()
        btnWriteReview.backgroundColor = appThemeColor
        btnWriteReview.addTarget(self, action: #selector(actionWriteReview(sender:)), for: UIControlEvents.touchUpInside)
        let WriteReview = UIBarButtonItem(customView: btnWriteReview)
        
        self.navigationItem.setRightBarButtonItems([WriteReview], animated: false)
    }
    
    
    @objc private func refreshEventsData(_ sender: Any) {
        pageNumber = 1
      //  isRefresh = true
//        refreshControl.beginRefreshing()
    }
}

//MARK:- UITableViewDelegate --

extension ShowAllReviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK:- UITableViewDataSource --

extension ShowAllReviewViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrReviewAll.count > 0 {
            return arrReviewAll.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.ShowAllReviewCellIdentifier) as! AllReviewShowTableViewCell
        if arrReviewAll.count > 0 {
            
            let bookdata = arrReviewAll[indexPath.item]
            let userdata = arrReviewAll[indexPath.item].user
            
            cell.userNameLbl.text = (userdata?.firstname)! + " " +  (userdata?.lastname)!
            if bookdata.description == ""{
                cell.reviewDescriptionLbl.text = ""
            }else {
                cell.reviewDescriptionLbl.text = bookdata.description
            }
            
            cell.profileImageBtn.setImage(UIImage(named: "profile_photo"), for: .normal)

            if userdata?.user_image != nil {
                if userdata?.viewprofile_pic == 0 {
                    cell.profileImageBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + (userdata?.user_image!)!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                }
            }
            
            cell.profileImageBtn.tag = indexPath.row
            cell.profileImageBtn.addTarget(self, action: #selector(actionUserProfile(_:)), for: .touchUpInside)
            
            
            let str = bookdata.created_at?.components(separatedBy: "T")[0]
            let date = CommonFunctions.sharedInstance.generateDate(str!, format: .format11)
            let strDate = CommonFunctions.sharedInstance.generateDateString(date, format: .format6)
            cell.reviewDateLbl.text = strDate
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(actionLikeUnlikeReview(sender:)), for: .touchUpInside)
            
            cell.likeBtn.setImage(UIImage(named: "like_white-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
            if bookdata.is_like == true {
                cell.likeBtn.tintColor = appThemeColor
            } else {
                cell.likeBtn.tintColor = UIColor.gray
            }
            cell.likeBtn.setTitleColor(UIColor.white, for: .normal)
            
            if (bookdata.likeCount)! > 0 {
                cell.likeBtn.setTitle(" \((bookdata.likeCount)!) ", for: .normal)
            } else {
                cell.likeBtn.setTitle("", for: .normal)
            }
            
            if (bookdata.commentCount)! > 0 {
                cell.commentBtn.setTitle(" \((bookdata.commentCount)!) ", for: .normal)
            } else {
                cell.commentBtn.setTitle("", for: .normal)
            }
            
            
            cell.commentBtn.addTarget(self, action: #selector(actionViewUserReview(sender:)), for: .touchUpInside)
            cell.ratingView.rating = bookdata.rating!
            cell.ratingView.text = "\((Float((bookdata.rating!))))"
            
        } else {
            
            tblReviewAll.register(UINib(nibName: ViewControllerIds.NoDataTableViewCell, bundle: nil), forCellReuseIdentifier: ViewControllerIds.NoDataTableViewCell)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.NoDataTableViewCell, for: indexPath) as! NoDataTableViewCell
            
            cell.lblNoData.text = localizedTextFor(key: NoDataFoundScene.NoReviewFound.rawValue)
            cell.lblNoData.textColor = UIColor.white
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  arrReviewAll.count > 0  {
            router?.navigateToUserReview(reviewId: "\((arrReviewAll[indexPath.row].id)!)")
        }
    }
}

//extension ShowAllReviewViewController : UIScrollViewDelegate {
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if scrollView == tblReviewAll {
//            
//            if (self.lastContentOffset <= scrollView.contentOffset.y) {
//                if #available(iOS 11.0, *) {
//                    self.navigationController?.navigationBar.prefersLargeTitles = true
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//            else if (self.lastContentOffset > scrollView.contentOffset.y) {
//                // move up
//                if #available(iOS 11.0, *) {
//                    self.navigationController?.navigationBar.prefersLargeTitles = false
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//            
//            // update the new position acquired
//            self.lastContentOffset = scrollView.contentOffset.y
//        }
//        
//    }
//}

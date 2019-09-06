

import UIKit
import Alamofire

typealias DeleteReviewCompletion = (_ data: Bool?) -> ()

protocol UserReviwDisplayLogic: class
{
    func displayDeleteReview(viewModel: UserReviw.ViewModel.DeleteReview)
    func displayUserResponse(viewModel: UserReviw.ViewModel)
    func displayLikeUnlikeReview(viewModel : ShowAllReview.LikeUnlikeModel, atIndex: Int)
}

class UserReviwViewController: UIViewController, UserReviwDisplayLogic
{
    var interactor: UserReviwBusinessLogic?
    var router: (NSObjectProtocol & UserReviwRoutingLogic & UserReviwDataPassing)?
    private var lastContentOffset: CGFloat = 0
    var reviewData = UserReviw.ViewModel.Review()
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
        let interactor = UserReviwInteractor()
        let presenter = UserReviwPresenter()
        let router = UserReviwRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    //MARK:- Outlet --
    
    @IBOutlet weak var UserReviewTblView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        userReviewRequest()
    }
    
    
    func setUpInterface(){
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ReviewDetailSceneTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)

        UserReviewTblView.tableFooterView = UIView()

    }
    
    
    //MARK: -- Button Action ==
    @objc func actionAddComment(_ sender: UIButton!) {

        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            router?.navigateToAddComment(reviewId: "\(reviewData.id!)")

        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    
    @objc func actionLikeUnlikeReview (sender: UIButton) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            var isLike : Bool = false
            if reviewData.is_like == true {
                isLike = false
            } else {
                isLike = true
            }
            
            let likeReq = ShowAllReview.Request.LikeUnlike.init(
                reviewId: "\(reviewData.id!)",
                isLike: isLike,
                index: sender.tag)
            interactor?.likeUnlikeReview(request: likeReq)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @objc func actionViewAllComment (sender:UIButton) {
    
        if reviewData.comment != nil {
            if (reviewData.comment?.count)! > 0 {
                let lastInd = (reviewData.comment?.count)! - 1
                UserReviewTblView.scrollToRow(at: IndexPath(row: lastInd, section: 0), at: .bottom, animated: true)
            }
        }

    }
    
    @objc func userDateButtonAction(sender:UIButton) {
       
        let dict:[String:Any] = ["rating":reviewData.rating!,"description":reviewData.description!,"bookId":"\(reviewData.id!)"]
        popToEditDeleteReview(onButton: sender, withData:dict, completionMethod: self.performDeleteReviewAction())
    }
    
    
    @objc func actionViewUserProfile(sender:UIButton) {

        var rederId : String?
        if sender.tag == 0 {
            rederId = "\((reviewData.user?.id)!)"
        } else {
            rederId = "\((reviewData.comment?[sender.tag].user?.id)!)"
        }
        router?.navigateToUserProfile(withId: rederId!)
    }
    
    
    //MARK: -- Request  ==
    
    func userReviewRequest(){
        interactor?.getUserReviewData()
    }
    
    func deleteUserReview() {
        interactor?.deleteMyReview()
    }
    
    //MARK: -- Response Action ==

    func displayUserResponse(viewModel: UserReviw.ViewModel)
    {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            reviewData = viewModel.reviewData!
            self.UserReviewTblView.reloadData()
        }
    }
    
    func displayLikeUnlikeReview(viewModel : ShowAllReview.LikeUnlikeModel, atIndex: Int) {
        
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            interactor?.getUserReviewData()
        }
    }
    
    func displayDeleteReview(viewModel: UserReviw.ViewModel.DeleteReview) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            router?.navigateBack()
        }
    }

    
    func performDeleteReviewAction() -> DeleteReviewCompletion {
        
        return { [unowned self] isComplete in
            if isComplete == true {
                self.deleteUserReview()
            }else{
                return
            }
        }
    }
}

//MARK:- UITableViewDelegate --

extension UserReviwViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }else{
            return UITableViewAutomaticDimension
        }
    }
}

//MARK:- UITableViewDataSource --
extension UserReviwViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if reviewData.comment != nil {
            if (reviewData.comment?.count)! > 0 {
                return (reviewData.comment?.count)! + 1
            } else {
                return 2
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.UserReviewSectionCellIdentifier) as! UserReviewTableViewCell
            cell.commentsLbl.text = localizedTextFor(key: UserReviewText.Comments.rawValue)
            
            let rev_User = reviewData.user!
            cell.userNameLbl.text = rev_User.firstname! + " " + rev_User.lastname!
            cell.userprofileBtn.setImage(UIImage(named: "profile_photo"), for: .normal)
            
            if rev_User.user_image != nil, let _ =  rev_User.user_image {
                if rev_User.viewprofile_pic == 0 {
                    cell.userprofileBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + rev_User.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                }
            }
            
            cell.userDescriptionLbl.text = reviewData.description
            let str = reviewData.created_at?.components(separatedBy: "T")[0]
            let date = CommonFunctions.sharedInstance.generateDate(str!, format: .format11)
            let strDate = CommonFunctions.sharedInstance.generateDateString(date, format: .format6)
            cell.userDateLbl.setTitle(strDate, for: .normal)
            cell.userprofileBtn.tag = indexPath.row
             cell.userprofileBtn.addTarget(self, action: #selector(actionViewUserProfile(sender:)), for: .touchUpInside)
            cell.btnAddComment.setTitle(localizedTextFor(key: UserReviewText.AddYourComment.rawValue), for: .normal)
            cell.btnAddComment.isHidden = false
            cell.btnAddComment.addTarget(self, action: #selector(actionAddComment(_:)), for: .touchUpInside)
            // Restrict user to comment on review
            if reviewData.user?.viewcomment != 0 {
                cell.btnAddComment.isHidden = true
            }
            
            if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
                
                if "\(reviewData.user_id!)" == CommonFunctions.sharedInstance.getUserId() {
                    cell.arrDD.isHidden = false
                    cell.userDateLbl.addTarget(self, action: #selector(userDateButtonAction(sender:)), for: .touchUpInside)
                } else {
                    cell.arrDD.isHidden = true
                }
            } else {
                cell.arrDD.isHidden = true
            }
            
            cell.userRatingView.rating = reviewData.rating!
            cell.userRatingView.text = "\(Float(reviewData.rating!))"
            
            
            cell.userLikeBtn.tag = indexPath.row
            cell.userLikeBtn.addTarget(self, action: #selector(actionLikeUnlikeReview(sender:)), for: .touchUpInside)
            cell.userCommntBtn.addTarget(self, action: #selector(actionViewAllComment(sender:)), for: .touchUpInside)

            cell.userLikeBtn.setImage(UIImage(named: "like_white-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
            if reviewData.is_like == true {
                cell.userLikeBtn.tintColor = appThemeColor
            } else {
                cell.userLikeBtn.tintColor = UIColor.gray
            }
            cell.userLikeBtn.setTitleColor(UIColor.white, for: .normal)
            
            if (reviewData.likeCount)! > 0 {
                cell.userLikeBtn.setTitle(" \((reviewData.likeCount)!) ", for: .normal)
            } else {
                cell.userLikeBtn.setTitle("", for: .normal)
            }
            
            if (reviewData.commentCount)! > 0 {
                cell.userCommntBtn.setTitle(" \((reviewData.commentCount)!) ", for: .normal)
            } else {
                cell.userCommntBtn.setTitle("", for: .normal)
            }
            
            return cell
            
        }else{
            
            if (reviewData.comment?.count)! > 0 {
                
                let commentData = reviewData.comment![indexPath.row-1]
                let comm_User = reviewData.comment![indexPath.row-1].user!
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.UserReviewCellIdentifier) as! UserReviewTableViewCell
                cell.commentUserNameLbl.text = comm_User.firstname! + " " + comm_User.lastname!
                cell.commentUserProfileBtn.setImage(UIImage(named: "profile_photo"), for: .normal)
                
                if comm_User.user_image != nil {
                    if comm_User.viewprofile_pic == 0 {
                        cell.commentUserProfileBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + comm_User.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                    }
                }
                
                cell.commentUserProfileBtn.tag = indexPath.row-1
                cell.commentUserProfileBtn.addTarget(self, action: #selector(actionViewUserProfile(sender:)), for: .touchUpInside)
                cell.commentUserCommentLbl.text = commentData.description
                let str = commentData.created?.components(separatedBy: "T")[0]
                let date = CommonFunctions.sharedInstance.generateDate(str!, format: .format11)
                let strDate = CommonFunctions.sharedInstance.generateDateString(date, format: .format6)
                cell.commentUserDateLbl.text = strDate
                
                return cell
            } else {
                
                UserReviewTblView.register(UINib(nibName: ViewControllerIds.NoDataTableViewCell, bundle: nil), forCellReuseIdentifier: ViewControllerIds.NoDataTableViewCell)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.NoDataTableViewCell, for: indexPath) as! NoDataTableViewCell
                
                cell.lblNoData.text = localizedTextFor(key: NoDataFoundScene.NoCommentFound.rawValue)
                cell.lblNoData.textColor = UIColor.white
                return cell
            }
            
        }
    }
}


//extension UserReviwViewController : UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if scrollView ==  UserReviewTblView {
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


import UIKit

protocol ShelfTypeDisplayLogic: class
{
    func displayShelfTypeResponse(viewModel: ShelfType.ViewModel)
}

class ShelfTypeViewController: UIViewController, ShelfTypeDisplayLogic
{
    var interactor: ShelfTypeBusinessLogic?
    var router: (NSObjectProtocol & ShelfTypeRoutingLogic & ShelfTypeDataPassing)?
    
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
        let interactor = ShelfTypeInteractor()
        let presenter = ShelfTypePresenter()
        let router = ShelfTypeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var ShelfTypeCollectionView: UICollectionView!
    var arrData = [ShelfType.ViewModel.CellData]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ShelfTypeCollectionView?.register(UINib(nibName: ViewControllerIds.BooksCollectionCell, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.BooksCollectionCell)
        if #available(iOS 11.0, *) {
            ShelfTypeCollectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        
        if  CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            if CommonFunctions.sharedInstance.getUserId() == router?.dataStore?.userId {
                // My profile
                
            } else{
                // reader
            }
            
        } else {
            // Reader Profile
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        getShelfData()
    }
    
    func setUpInterface(){
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: (router?.dataStore?.navTitle)!))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
    }
    
    func getShelfData(){
        interactor?.getShelfTypeApi()
    }
    func displayShelfTypeResponse(viewModel: ShelfType.ViewModel) {
        
        arrData = viewModel.collectionArray
        ShelfTypeCollectionView.reloadData()
    }
    
    
    
    @objc func actionAllReviews(_ sender: UIButton) {
        if arrData.count > 0 {
            router?.navigateToAllReview(bookId: "\((arrData[sender.tag].bookId)!)")
        }
    }
    
    
    @objc func actionReadFavouriteUnfavorite(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
                var param: [String : Any]?
                
                let likeStatus = arrData[sender.tag].is_favourite == true ? false : true
                
                param = [
                    "id":arrData[sender.tag].id!,
                    "user_id":router?.dataStore?.userId!,
                    "is_favourite":likeStatus
                ]
                
                CommonFunctions.sharedInstance.hitFavouriteUnfavouriteApi(withData: param!) { (response) in
                    if response.code == SuccessCode {
                        let result = response.result as! NSDictionary
                        CustomAlertController.sharedInstance.showSuccessAlert(success: (result["result"] as? String)!)
                        
                        if CommonFunctions.sharedInstance.getUserId() == self.router?.dataStore?.userId {
                            self.arrData.remove(at: sender.tag)
                            self.ShelfTypeCollectionView?.reloadData()
                        } else {
                            self.arrData[sender.tag].is_favourite = likeStatus
                            self.ShelfTypeCollectionView?.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
                        }
                        
                    } else {
                        CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                    }
                }
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
        
    }
    
    @objc func actionAddToShelves(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
                let data:[String:Any] = ["book_id":arrData[sender.tag].bookId!,"shelf_status":arrData[sender.tag].shelf_status!,"is_favourite":arrData[sender.tag].is_favourite, "isFrom":"", "cover_photo":arrData[sender.tag].cover_photo!, "name":arrData[sender.tag].name!]
            
            
                router?.navigateToBookShelves(withData: data)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
//    func performBookPopUpAction() -> MyBookShelfPopUp {
//
//        return { [unowned self] status, oldStatus in
//            if status >= 3 {
//                return
//            }else if status == oldStatus {
//                return
//            } else {
//                //                if oldStatus == 0 {
//                //
//                //                } else if oldStatus == 1 {
//                //
//                //                } else if oldStatus == 2 {
//                //
//                //                }
//                self.interactor?.getShelfTypeApi()
//            }
//        }
//    }
    
}

extension ShelfTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       // if arrData.count > 0 {
            return CGSize(width: (collectionView.frame.size.width-20)/2, height: (TotalWidth-60)/2*1.7)
//        } else {
//            return CGSize(width: collectionView.frame.size.width, height: 35)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //if  arrData.count > 0 {
            return arrData.count
//        } else {
//            return 1
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if  arrData.count > 0 {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.BooksCollectionCell, for: indexPath) as! BooksCollectionViewCell
            
            let currentObj = arrData[indexPath.item]
            
            cell.imgBookCover.sd_setImage(with: URL(string: currentObj.cover_photo!), placeholderImage: UIImage(named: "defaultBookImage"))
            cell.lblBookName.text = currentObj.name
            cell.lblAuthorName.text = currentObj.author_name

            cell.ratingView.settings.totalStars = 7
            cell.ratingView.rating = currentObj.rating!
            cell.ratingView.text = "\((Float(currentObj.rating!)))"

            let strReview = " \((currentObj.review_count)!) \((localizedTextFor(key: GeneralText.ReviewsTitle.rawValue))) "
            cell.btnReviews.setTitle(strReview, for: .normal)
            
            
            // for example
            if let _ = currentObj.review_count {
                
                if currentObj.is_favourite == true {
                    cell.btnFavUnfav.tintColor = appThemeColor
                } else {
                    cell.btnFavUnfav.tintColor = UIColor.gray
                }
            }
            
            cell.btnReviews.tag = indexPath.item
            cell.btnReviews.addTarget(self, action: #selector(actionAllReviews(_:)), for: .touchUpInside)
            cell.btnFavUnfav.tag = indexPath.item
            cell.btnFavUnfav.addTarget(self, action: #selector(actionReadFavouriteUnfavorite(_:)), for: .touchUpInside)
            cell.btnBookSelf.tintColor = appThemeColor
            cell.btnBookSelf.tag = indexPath.item
            cell.btnBookSelf.addTarget(self, action: #selector(actionAddToShelves(_:)), for: .touchUpInside)
            
            return cell
            
       // }
//        else {
//
//            ShelfTypeCollectionView.register(UINib(nibName: ViewControllerIds.NoDataFoundCellIndetifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.NoDataFoundCellIndetifier)
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.NoDataFoundCellIndetifier, for: indexPath) as! NoDataCollectionViewCell
//            cell.lblNoDataFound.text = localizedTextFor(key: NoDataFoundScene.NoBookFound.rawValue)
//            cell.lblNoDataFound.textColor = UIColor.white
//
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  arrData.count > 0 {
            router?.navigateToBookDetail(bookId: "\((arrData[indexPath.row].bookId)!)")
        }
    }
}

extension ShelfTypeViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset <= scrollView.contentOffset.y) {
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = true
            } else {
                // Fallback on earlier versions
            }
        }
        else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = false
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
}


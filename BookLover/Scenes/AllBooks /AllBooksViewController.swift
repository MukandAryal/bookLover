

import UIKit

protocol AllBooksDisplayLogic: class
{
    func displayAllBook(viewModel: AllBooks.ViewModel)
}

class AllBooksViewController: UIViewController, AllBooksDisplayLogic
{
    var interactor: AllBooksBusinessLogic?
    var router: (NSObjectProtocol & AllBooksRoutingLogic & AllBooksDataPassing)?
    
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
        let interactor = AllBooksInteractor()
        let presenter = AllBooksPresenter()
        let router = AllBooksRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
   
    //////////////////////////////////////////////////////
    
    @IBOutlet weak var AllBooksCollectionView: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!

    private var lastContentOffset: CGFloat = 0
    var pageNumber : Int?
    var isLoading : Bool?
    var isRefresh : Bool?
    var isSearching : Bool?
    var arrayAllBooks = [AllBooks.ViewModel.allBooks]()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            AllBooksCollectionView?.contentInsetAdjustmentBehavior = .always
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageNumber = 1
        arrayAllBooks.removeAll()
        setUpInterface()
        bookRequest(page: pageNumber!, query: "")
        AllBooksCollectionView .reloadData()
    }
    
    
    //MARK:- Request Methods --

    func bookRequest(page: Int, query: String){
        tfSearch.resignFirstResponder()
        let bookReq = AllBooks.Request(query: query, z)
        interactor?.getAllBookData(request: bookReq)
    }
    
   
    //MARK:- Response Methods --

    func displayAllBook(viewModel: AllBooks.ViewModel) {

        refreshControl.endRefreshing()
        if viewModel.error != nil {
            isLoading = true
            if viewModel.error == Error404 {
                return
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
            }
        } else {
            
            isLoading = false
            printToConsole(item: "arr count ---- \((viewModel.booksList!.count))")
            if viewModel.booksList!.count > 0 {
                if isRefresh == true || isSearching == true  {
                    arrayAllBooks.removeAll()
                    arrayAllBooks = viewModel.booksList!
                    pageNumber = pageNumber! + 1
                    isRefresh = isRefresh == true ? false : isRefresh
                    isSearching = isSearching == true ? false : isSearching
                } else {
                    pageNumber = pageNumber! + 1
                    arrayAllBooks.append(contentsOf: viewModel.booksList!)
                }
            } else {
                arrayAllBooks.removeAll()
            }
            AllBooksCollectionView.reloadData()
        }
    }
    
    
    //MARK:- Class Helper Methods --

    func setUpInterface(){
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: router?.dataStore?.navTitle)
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)

        if #available(iOS 11.0, *) {
            AllBooksCollectionView.refreshControl = refreshControl
        } else {
            AllBooksCollectionView.addSubview(refreshControl)
        }
        
        refreshControl.tintColor = appThemeColor
        
        refreshControl.addTarget(self, action: #selector(refreshEventsData(_:)), for: .valueChanged)
        
        AllBooksCollectionView.register(UINib(nibName: ViewControllerIds.BooksCollectionCell, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.BooksCollectionCell)
        
        tfSearch.text = ""
        tfSearch.textColor = UIColor.white
        tfSearch.attributedPlaceholder = NSAttributedString(string: localizedTextFor(key: SearchMyFriendText.Search.rawValue),
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        tfSearch.layer.borderWidth = 1
        tfSearch.layer.borderColor = UIColor.lightGray.cgColor
        tfSearch.layer.cornerRadius = tfSearch.frame.size.height/2.0
        tfSearch.clipsToBounds = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30
            , height: 40))
        view.backgroundColor = UIColor.clear
        let button = UIButton(frame: CGRect(x: 10, y: 12.5, width: 15
            , height: 15))
        button.setImage(UIImage(named: "serch"), for: .normal)
        view.addSubview(button)
        tfSearch.leftView = view
        tfSearch.leftViewMode = .always
    }
    
    @objc private func refreshEventsData(_ sender: Any) {
        tfSearch.text = ""
        pageNumber = 1
        isRefresh = true
        refreshControl.beginRefreshing()
        bookRequest(page: pageNumber!, query: "")
    }
    
    func presentAddToShelfError() {
        CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: HomeValidationText.AddToShelf.rawValue))
    }
    
    func performBookPopUpAction() -> BookPopUpCompletion {
        
        return { [unowned self] isWriteReview, onBook  in
            if isWriteReview == true {
                self.router?.navigateToRatingView(bookId: onBook!)
            }else{
                return
            }
        }
    }
    
    //MARK:- Cell Interface Builder Method --
    
    @objc func actionFavouriteUnfavorite(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            var param: [String : Any]?
            
            if (arrayAllBooks[sender.tag].shelves?.count)! > 0 {
                let likeStatus = ((arrayAllBooks[sender.tag].shelves)![0].is_favourite)! == true ? false : true
                param = [
                    "id":"\(((arrayAllBooks[sender.tag].shelves)![0].id)!)",
                    "user_id":CommonFunctions.sharedInstance.getUserId(),
                    "is_favourite":likeStatus]
            } else {
                presentAddToShelfError()
                return
            }
            
            CommonFunctions.sharedInstance.hitFavouriteUnfavouriteApi(withData: param!) { (response) in
                
                if response.code == SuccessCode {

                    let result = response.result as! NSDictionary
                    
                    CustomAlertController.sharedInstance.showSuccessAlert(success: (result["result"] as? String)!)
                    
                    var popData = self.arrayAllBooks[sender.tag]
                    var shelfData = popData.shelves![0]
                    shelfData.is_favourite = shelfData.is_favourite == true ? false : true
                    popData.shelves![0] = shelfData
                    self.arrayAllBooks[sender.tag] = popData
                    self.AllBooksCollectionView.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])

                } else {
                    CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
                }
            }
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
    @objc func actionAllReviews(_ sender: UIButton) {
        
        if arrayAllBooks.count > 0 {
            router?.navigateToAllReview(bookId: "\((arrayAllBooks[sender.tag].id)!)")
        }
    }
    
    @objc func actionAddToShelves(_ sender: UIButton) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            var status: Int?
            var isLike: Bool?
            
            if (arrayAllBooks[sender.tag].shelves?.count)! > 0 {
                status = (arrayAllBooks[sender.tag].shelves)![0].shelf_status
                isLike = (arrayAllBooks[sender.tag].shelves)![0].is_favourite
            } else {
                status = 3
                isLike = false
            }
            
            let data:[String:Any] = ["book_id":(arrayAllBooks[sender.tag].id)!,"shelf_status":status!,"is_favourite":isLike!,"isFrom":"Home", "cover_photo":arrayAllBooks[sender.tag].cover_photo!, "name":arrayAllBooks[sender.tag].name!]
             router?.navigateToBookShelves(withData: data)
        } else {
            CustomAlertController.sharedInstance.showLoginFirstAlert()
        }
    }
    
}

extension AllBooksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if arrayAllBooks.count > 0 {
            return CGSize(width: (collectionView.frame.size.width-20)/2, height: (TotalWidth-60)/2*1.7)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrayAllBooks.count > 0 {
           return arrayAllBooks.count
        } else {
           return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  arrayAllBooks.count > 0 {
            
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.BooksCollectionCell, for: indexPath) as! BooksCollectionViewCell
            
            cell.imgBookCover.backgroundColor = UIColor.clear
            let data = arrayAllBooks[indexPath.item]
            cell.imgBookCover.sd_setImage(with: URL(string:data.cover_photo!), placeholderImage: UIImage(named: "defaultBookImage"))
            cell.lblBookName.text = data.name
            cell.lblAuthorName.text = data.author_name
            cell.ratingView.settings.totalStars = 1
            cell.ratingView.rating = data.rating!
            cell.ratingView.text = "\((Float(data.rating!)))"

            
            let strReview = " \((data.review_count)!) \((localizedTextFor(key: GeneralText.ReviewsTitle.rawValue))) "
            cell.btnReviews.setTitle(strReview, for: .normal)

            
            cell.btnReviews.tag = indexPath.item
            cell.btnReviews.addTarget(self, action: #selector(actionAllReviews(_:)), for: .touchUpInside)
            cell.btnFavUnfav.tag = indexPath.item
            cell.btnFavUnfav.addTarget(self, action: #selector(actionFavouriteUnfavorite(_:)), for: .touchUpInside)
            cell.btnBookSelf.tag = indexPath.item
            cell.btnBookSelf.addTarget(self, action: #selector(actionAddToShelves(_:)), for: .touchUpInside)
            
            if data.shelves!.count > 0 {
                if data.shelves![0].is_favourite == true {
                    cell.btnFavUnfav.tintColor = appThemeColor
                } else {
                    cell.btnFavUnfav.tintColor = UIColor.gray
                }
                cell.btnBookSelf.tintColor = appThemeColor
                
            } else {
                cell.btnFavUnfav.tintColor = UIColor.gray
                cell.btnBookSelf.tintColor = UIColor.gray
            }
            
            return cell

        } else {
            
            AllBooksCollectionView.register(UINib(nibName: ViewControllerIds.NoDataFoundCellIndetifier, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.NoDataFoundCellIndetifier)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewControllerIds.NoDataFoundCellIndetifier, for: indexPath) as! NoDataCollectionViewCell
            cell.lblNoDataFound.text = localizedTextFor(key: NoDataFoundScene.NoBookFound.rawValue)
            cell.lblNoDataFound.textColor = UIColor.white

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  arrayAllBooks.count > 0 {
            router?.navigateToBookDetail(bookId: "\((arrayAllBooks[indexPath.row].id)!)")
        }
    }
}

extension AllBooksViewController: UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        pageNumber = 1
        isSearching = true
        if  (textField.text?.count)! > 0 {
            bookRequest(page: pageNumber!, query: textField.text_Trimmed())
        } else {
            bookRequest(page: pageNumber!, query: "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
}


extension AllBooksViewController: UIScrollViewDelegate
{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == AllBooksCollectionView {
            
            if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
                if isLoading == false {
                    isLoading = true
                    tfSearch.text = ""
                    bookRequest(page: pageNumber!, query: "")
                }
                
            } 
        }
    }
}



import UIKit

protocol SearchBookDisplayLogic: class
{
    func displaySearchBook(viewModel:SearchBook.ViewModel)
}

class SearchBookViewController: UIViewController, SearchBookDisplayLogic
{
    var interactor: SearchBookBusinessLogic?
    var router: (NSObjectProtocol & SearchBookRoutingLogic & SearchBookDataPassing)?
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
        let interactor = SearchBookInteractor()
        let presenter = SearchBookPresenter()
        let router = SearchBookRouter()
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
    
    ////////////////////////////////////////////////////////
    
    @IBOutlet weak var tblSearchBook: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    private var lastContentOffset: CGFloat = 0
    private let refreshControl = UIRefreshControl()
    var pageNumber: Int = 1
    var isLoading : Bool?
    var isRefresh : Bool?
    var isSearching : Bool?

    //  let searchStr: String?
    var arraySearchBooks = [SearchBook.ViewModel.searchBook]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        searchBookRequest(updatedString: "", page: pageNumber)
    }
    
    //MARK:- Class Helper --
    
    func setUpInterface(){
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: GeneralText.SearchTitle.rawValue))
        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)

        if #available(iOS 11.0, *) {
            tblSearchBook.refreshControl = refreshControl
        } else {
            tblSearchBook.addSubview(refreshControl)
        }

        refreshControl.tintColor = appThemeColor
        refreshControl.addTarget(self, action: #selector(refreshEventsData(_:)), for: .valueChanged)
        
        tfSearch.text = ""
        tfSearch.textColor = UIColor.white
       // tfSearch.addTarget(self, action: #selector(textFeildDidChange(_:)), for: .editingChanged)
        tfSearch.attributedPlaceholder = NSAttributedString(string: localizedTextFor(key: SearchMyFriendText.Search.rawValue),
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        tfSearch.layer.borderWidth = 1
       // (red: 56/255.0, green: 56/255.0, blue: 56/255.0, alpha: 1)
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
        tblSearchBook.tableFooterView = UIView()
    }
    
    
    @objc private func refreshEventsData(_ sender: Any) {
        pageNumber = 1
        isRefresh = true
        tfSearch.text = ""
        refreshControl.beginRefreshing()
        searchBookRequest(updatedString: "", page: pageNumber)
    }
    
    //MARK:- Requset Method --
    
    @objc func searchBookRequest(updatedString: String, page: Int){
        
       // tfSearch.resignFirstResponder()
        let request = SearchBook.Request.searchTextRequest(updatedSearchString: updatedString, page: page)
        interactor?.getSearchBookData(request: request)
    }
    
    func displaySearchBook(viewModel: SearchBook.ViewModel) {
        
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
            printToConsole(item: "arr count ---- \((viewModel.searchbooksList!.count))")
            if viewModel.searchbooksList!.count > 0 {
                if isRefresh == true || isSearching == true  {
                   arraySearchBooks.removeAll()
                   arraySearchBooks = viewModel.searchbooksList!
                   isRefresh = false
                   pageNumber = pageNumber + 1
                   isRefresh = isRefresh == true ? false : isRefresh
                   isSearching = isSearching == true ? false : isSearching
                } else {
                    pageNumber = pageNumber + 1
                    arraySearchBooks.append(contentsOf: viewModel.searchbooksList!)
//                    tblSearchBook.reloadData()
                }
            } else {
                arraySearchBooks.removeAll()
            }
            tblSearchBook.reloadData()
        }
    }
   
}


//MARK:- Scroll Delegate

extension SearchBookViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tblSearchBook {
            if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
                if isLoading == false {
                    isLoading = true
                    tfSearch.text = ""
                    searchBookRequest(updatedString: "", page: pageNumber)
                }
            }
        }
    }
}

//MARK:- UITexfFeild Delegate

extension SearchBookViewController: UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
//    func textField(_ textField: UITextField,
//                   shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//
//        if let text = textField.text,
//            let textRange = Range(range, in: text) {
//
//            let txtAfterUpdate = text.replacingCharacters(in: textRange,
//                                                       with: string)
//
//
//            pageNumber = 1
//            isSearching = true
//            NSObject.cancelPreviousPerformRequests(
//                withTarget: self,
//                selector: #selector(self.searchBookRequest),
//                object: textField)
//
//            self.perform(
//                #selector(self.searchBookRequest),
//                with: textField,
//                afterDelay: 0.5)
//
////            if txtAfterUpdate.count > 0 {
////                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
////                    self.searchBookRequest(updatedString: txtAfterUpdate, page: self.pageNumber)
////                }
////            }else {
////                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
////                    self.searchBookRequest(updatedString: txtAfterUpdate, page: self.pageNumber)
////                }
////            }
//        }
//        return true
//    }
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let txtAfterUpdate =  (tfSearch.text! as NSString).replacingCharacters(in: range, with: string)
//        pageNumber = 1
//        isSearching = true
//        if txtAfterUpdate.count > 0 {
//            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                self.searchBookRequest(updatedString: txtAfterUpdate, page: self.pageNumber)
//            }
//        }else {
//            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                self.searchBookRequest(updatedString: txtAfterUpdate, page: self.pageNumber)
//            }
//        }
//        return true
//    }
    
//    @objc func textFeildDidChange(_ textField: UITextField?) {
//
//        pageNumber = 1
//        isSearching = true
//        if  ((textField?.text_Trimmed())?.count)! > 0 {
//            self.searchBookRequest(updatedString: (textField?.text_Trimmed())!, page: self.pageNumber)
//        } else {
//            //DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.searchBookRequest(updatedString: "", page: self.pageNumber)
//        }
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        pageNumber = 1
        isSearching = true
        if  (textField.text?.count)! > 0 {
            self.searchBookRequest(updatedString: textField.text_Trimmed(), page: self.pageNumber)
        } else {
            self.searchBookRequest(updatedString: "", page: self.pageNumber)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
}


//MARK:- Table Delegate

extension SearchBookViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arraySearchBooks.count > 0 {
            router?.navigateToBookDetail(bookId: "\((arraySearchBooks[indexPath.item].id)!)")
        }
    }
}



//MARK:- Table DataSource

extension SearchBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arraySearchBooks.count > 0 {
            return arraySearchBooks.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if arraySearchBooks.count > 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.SearchBookTableViewCell) as! SearchBookTableViewCell

            let data = arraySearchBooks[indexPath.item]
            cell.bookImageView.sd_setImage(with: URL(string: data.cover_photo!), placeholderImage: UIImage(named: "defaultBookIcon"))
            cell.booknameLbl.text = data.name
            cell.authornameLbl.text = data.author_name
            return cell

        } else {
            
            tblSearchBook.register(UINib(nibName: ViewControllerIds.NoDataTableViewCell, bundle: nil), forCellReuseIdentifier: ViewControllerIds.NoDataTableViewCell)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.NoDataTableViewCell, for: indexPath) as! NoDataTableViewCell
            
            cell.lblNoData.text = localizedTextFor(key: NoDataFoundScene.NoBookFound.rawValue)
            cell.lblNoData.textColor = UIColor.white
            return cell
        }
    }
}



import UIKit

protocol ShareTheBookDisplayLogic: class
{
    func displayfriendList(viewModel: ShareTheBook.ViewModel)
    func displayShareTheBookResponse(viewModel: ShareTheBook.ViewModel.ShareTheBook)
}

class ShareTheBookViewController: UIViewController, ShareTheBookDisplayLogic
{
    var interactor: ShareTheBookBusinessLogic?
    var router: (NSObjectProtocol & ShareTheBookRoutingLogic & ShareTheBookDataPassing)?
    
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
        let interactor = ShareTheBookInteractor()
        let presenter = ShareTheBookPresenter()
        let router = ShareTheBookRouter()
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
    
    ///////////////////////////////////////////////////////////////
    
    //MARK Oultet Helper :-
    var arrfriendList = [ShareTheBook.ViewModel.FreindInfo]()
    var arrSearch = [ShareTheBook.ViewModel.FreindInfo]()
    var isSearch: Bool = false
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var btnSharebBook: UIButtonFontSize!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tblFriendList: UITableView!
    
      //MARK:- viewDidLoad Helper :--
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
     //MARK:- viewWillAppear Helper :--
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        freindList()
        tblFriendList.tableFooterView = UIView()
    }
    
    //MARK:- Class Helper :--
    func setUpInterface(){
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ShareBooksSceneTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        btnSharebBook.layer.cornerRadius = btnSharebBook.layer.frame.size.height/2
        btnSharebBook.clipsToBounds = true;
        btnSharebBook.setTitle(localizedTextFor(key: SceneTitleText.ShareBooksSceneTitle.rawValue), for: .normal)
        //        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: router?.dataStore?.navTitle)
        //        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
        //        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        //
        //        if #available(iOS 11.0, *) {
        //            AllBooksCollectionView.refreshControl = refreshControl
        //        } else {
        //            AllBooksCollectionView.addSubview(refreshControl)
        //        }
        //
        //        refreshControl.tintColor = appThemeColor
        //        //        refreshControl.attributedTitle = NSAttributedString(string: RefreshControlAttributedTextKey, attributes:[NSAttributedStringKey.foregroundColor: UIColor.black])
        //
        //        refreshControl.addTarget(self, action: #selector(refreshEventsData(_:)), for: .valueChanged)
        //
        //        AllBooksCollectionView.register(UINib(nibName: ViewControllerIds.BooksCollectionCell, bundle: nil), forCellWithReuseIdentifier: ViewControllerIds.BooksCollectionCell)
        
        tfSearch.text = ""
        tfSearch.textColor = UIColor.white
        tfSearch.addTarget(self, action: #selector(textFeildDidChange(_:)), for: .editingChanged)
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
    
    @objc func textFeildDidChange(_ textField: UITextField?) {
        
        let strTextTrim = textField?.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if (strTextTrim?.count ?? 0) > 0 {
            isSearch = true
           // let bPredicate = NSPredicate(format: "firstname contains[c] %@", (textField?.text)!)
            arrSearch = arrfriendList.filter {
                return $0.firstname?.range(of: strTextTrim!, options: .caseInsensitive) != nil
            }
            for (ind, var obj) in  arrSearch.enumerated() {
                obj.isSelected = false
                arrSearch[ind] = obj
            }
            tblFriendList.reloadData()
        } else {
            isSearch = false
            tblFriendList.reloadData()
        }
    }
    
    
    //MARK:- Freind List Request Helper :--
    
    func freindList()
    {
        interactor?.getFriendList()
    }
    
    
    //MARK:- Display Freind List Helper :--
    
    func displayfriendList(viewModel: ShareTheBook.ViewModel) {
        
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        }else{
            arrfriendList = viewModel.friendList!
            printToConsole(item: arrfriendList)
            tblFriendList.reloadData()
        }
    }
    
    func updateSelectedCount()  {
        
        var count : Int = 0
        
        var frndList = [ShareTheBook.ViewModel.FreindInfo]()
        if isSearch != true {
            frndList = arrfriendList
        } else {
            frndList = arrSearch
        }
        
        for obj in frndList {
            if obj.isSelected == true{
                count = count + 1
            }
        }
        
        if count > 0 {
            let strTitle = localizedTextFor(key: SceneTitleText.ShareBooksSceneTitle.rawValue) + "(\(count))"
            btnSharebBook.setTitle(strTitle, for: .normal)
        } else {
            btnSharebBook.setTitle(localizedTextFor(key: SceneTitleText.ShareBooksSceneTitle.rawValue), for: .normal)
        }
    }
    
    
    //MARK:- Display ShareTheBook Helper :--
    func displayShareTheBookResponse(viewModel: ShareTheBook.ViewModel.ShareTheBook) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
            //result
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    //MARK:-  Action ShareTheBook Helper :--
    @IBAction func actionShareBook(_ sender: Any) {
        
        var frndList = [ShareTheBook.ViewModel.FreindInfo]()
        if isSearch != true {
            frndList = arrfriendList
        } else {
            frndList = arrSearch
        }
        
        let strCount : NSMutableString = ""
        for obj in frndList {
            if obj.isSelected == true{
                strCount.append("\((obj.id)!),")
            }
        }
        
        var strIm = strCount as String
        if strCount.length>0 {
            strIm.removeLast()
        }
        let requestShareBook = ShareTheBook.Request(from_user_id: strIm)
        interactor?.shareApiRequest(request: requestShareBook)
    }
}

//MARK:- UITableViewDelegate :--
extension ShareTheBookViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK:- UITableViewDataSource :--
extension ShareTheBookViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearch.count
        } else {
            return arrfriendList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerIds.freindlistCellIdentifier) as! ShareTheBookTableViewCell
        
        if arrfriendList.count > 0 {
            
            var frnddata = ShareTheBook.ViewModel.FreindInfo()
            if isSearch != true {
                frnddata = arrfriendList[indexPath.item]
            } else {
                frnddata = arrSearch[indexPath.item]
            }
            
            let strName : NSMutableString = ""
            if frnddata.firstname != nil, let _ = frnddata.firstname {
                strName.append((frnddata.firstname)!)
                strName.append(" ")
            }
            if frnddata.lastname != nil, let _ = frnddata.lastname {
                strName.append((frnddata.lastname)!)
            }
            if strName == ""{
                cell.userNameLbl.text = localizedTextFor(key: NoDataFoundScene.NoFriendFound.rawValue)
            }else {
                cell.userNameLbl.text = strName as String
            }
            
            if frnddata.user_image != nil, let _ = frnddata.user_image {
                cell.userProfileBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + frnddata.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
            } else {
                cell.userProfileBtn.setImage(UIImage(named: "profile_photo"), for: .normal)
            }
            
            if frnddata.isSelected != false {
                cell.checkBoxImageView.image = #imageLiteral(resourceName: "checkbox")
                cell.userProfileBtn.layer.borderColor = UIColor.yellow.cgColor
            }else {
                cell.checkBoxImageView.image = #imageLiteral(resourceName: "check_black")
                cell.userProfileBtn.layer.borderColor = UIColor.gray.cgColor
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var frnddata = ShareTheBook.ViewModel.FreindInfo()
        if isSearch != true {
            frnddata = arrfriendList[indexPath.item]
        } else {
            frnddata = arrSearch[indexPath.item]
        }
        
        if frnddata.isSelected != true {
            frnddata.isSelected = true
        }else {
            frnddata.isSelected = false
        }
        
        if isSearch != true {
            arrfriendList[indexPath.row] = frnddata
        } else {
            arrSearch[indexPath.row] = frnddata
        }
        tblFriendList.reloadRows(at: [indexPath], with: .fade)
        updateSelectedCount()
    }
}

//extension ShareTheBookViewController : UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if scrollView == tblFriendList {
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

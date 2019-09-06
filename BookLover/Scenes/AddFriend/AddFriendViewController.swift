
import UIKit
import Alamofire

protocol AddFriendDisplayLogic: class
{
    func displayGetFriendsList(viewModel: AddFriend.ViewModel)
    func displaySendRequsetInfo(viewModel:AddFriend.ViewModel.ReportUser, atIndex: Int)
    func displayCancelRequsetInfo(viewModel:AddFriend.ViewModel.ReportUser, atIndex: Int)
}

class AddFriendViewController: UIViewController, AddFriendDisplayLogic, getFilterData
{
    var IsRequest: Bool?
    var strFriendObjId: String?
    var interactor: AddFriendBusinessLogic?
    var router: (NSObjectProtocol & AddFriendRoutingLogic & AddFriendDataPassing)?
    
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
        let interactor = AddFriendInteractor()
        let presenter = AddFriendPresenter()
        let router = AddFriendRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Button OutLet --
    
    @IBOutlet weak var readerTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var lblNoDataFound: UILabelFontSize!
    var arrGetReaders = [AddFriend.ViewModel.userInfo]()
    var pageNumber: Int = 1
    var getFiltersObj: [String:Any]?
    
    // MARK: viewDidLoad --
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblNoDataFound.text = localizedTextFor(key: localizedTextFor(key: NoDataFoundScene.NoFriendMatch.rawValue))
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.AddFriendSceneTitle.rawValue))
    }
    
    
    func setFiltersData(_ obj: [String: Any]) {
        getFiltersObj = obj
        interactor?.IsFilterGetFriend(isFilter:(getFiltersObj!["isFilter"] != nil), isGender: getFiltersObj!["isGender"] as! String, nearMe: getFiltersObj!["nearMe"] as! String,age: getFiltersObj!["age"] as! [Int], country: getFiltersObj!["country"] as! String, state: getFiltersObj!["state"] as! String,strCountryId:getFiltersObj!["strCountryId"] as! String)
    }
    
    
    // MARK: getFriends --
    func getFriends() {
        interactor?.apiAddFriend()
    }
    
    // MARK: viewWillAppear --
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        setUpInterface()
        getFriends()
        // readerTableView.reloadData()
    }
    
    // MARK: Class Helper --
    func setUpInterface(){
        lblNoDataFound.isHidden = true
        readerTableView.tableFooterView = UIView()
        filterButton.layer.cornerRadius = filterButton.frame.size.height/2.0
        filterButton.clipsToBounds = true
    }
    
    // MARK: viewDidLayoutSubviews --
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = appBackGroundColor
    }
    
    // MARK: Display Get Friends --
    func displayGetFriendsList(viewModel: AddFriend.ViewModel)
    {
        if viewModel.error != nil {
            // aleart
        }else{
            arrGetReaders.removeAll()
            arrGetReaders.append(contentsOf: viewModel.frindList!)
           if arrGetReaders.count == 0 {
                 lblNoDataFound.isHidden = false
            }
            readerTableView.reloadData()
        }
    }
    
    //MARK:- DisplaySendRequsetInfo --
    func displaySendRequsetInfo(viewModel: AddFriend.ViewModel.ReportUser, atIndex: Int) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            getFriends()
            readerTableView.reloadData()
        }
    }
    
    func displayCancelRequsetInfo(viewModel: AddFriend.ViewModel.ReportUser, atIndex: Int) {
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
            getFriends()
            readerTableView.reloadData()
        }
    }
    
    // MARK: CEll Button Action
    @objc func actionaddButton(_ sender: UIButton) {
        
        let reqAddFriend = AddFriend.Request.addFriend(ffriend_id: "\((arrGetReaders[sender.tag].id)!)",index: sender.tag)
        interactor?.sendFriendRequestApi(request:reqAddFriend)
        
    }
    
    @objc func actionCancalButton(_ sender: UIButton) {
        let reqCancalFriend = AddFriend.Request.cancalRequest(id: "\((arrGetReaders[sender.tag].frnd?.id)!)",index: sender.tag)
        interactor?.cancelFriendRequestApi(request:reqCancalFriend)
        
    }
    
    @objc func actionViewUserProfile(_ sender: UIButton) {
        router?.navigateToUserProfile(withId: "\((arrGetReaders[sender.tag].id)!)")
    }
    
    // MARK: Button Action --
    
    @IBAction func filterButtonAction(_ sender: Any) {
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        router?.navigateToSearchMyFriend()
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        let vcObj = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIds.FilterAge) as? FilterViewController
        let navCon = UINavigationController(rootViewController: vcObj!)
        vcObj?.delegate = self
        vcObj?.filtersObj = getFiltersObj
        self.present(navCon, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate --
extension AddFriendViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGetReaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddFriendReaderTableViewCell
        if arrGetReaders.count > 0 {
            let readersData = arrGetReaders[indexPath.item]
            let fullName : NSMutableString = ""
            if readersData.firstname != nil, let _ = readersData.firstname {
                fullName.append((readersData.firstname)!)
                fullName.append(" ")
            }
            if readersData.lastname != nil, let _ = readersData.lastname {
                fullName.append((readersData.lastname)!)
            }
            if fullName == ""{
                cell.userNameLabel.text = " "
            }else {
                cell.userNameLabel.text = fullName as String
            }
            let ageGender : NSMutableString = ""
            if readersData.age != nil, let _ = readersData.age {
                ageGender.append("\(readersData.age!),")
                ageGender.append(" ")
            }
            if readersData.gender != nil, let _ = readersData.gender {
                ageGender.append((readersData.gender)!)
            }
            
            if ageGender == ""{
                cell.userAgeLabel.text = " "
            }else {
                cell.userAgeLabel.text = ageGender as String
            }
            
            let location : NSMutableString = ""
            if readersData.state != nil, let _ = readersData.state {
                location.append("\(readersData.state!),")
                location.append(" ")
            }
            if readersData.country != nil, let _ = readersData.country {
                location.append((readersData.country)!)
            }
            if location == ""{
                cell.userLocationLabel.text = " "
            }else {
                cell.userLocationLabel.text = location as String
            }
            
            cell.userImgBtn.setImage(UIImage(named: "profile_photo"), for: .normal)
            if readersData.user_image != nil, let _ = readersData.user_image {
                
                if readersData.Privacies?.profile_pic == 0 {
                      cell.userImgBtn.sd_setImage(with: URL(string: Configurator.imageBaseUrl + readersData.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                }
              
            }
            
            cell.userImgBtn.tag = indexPath.row
            cell.userImgBtn.addTarget(self, action: #selector(actionViewUserProfile(_:)), for: .touchUpInside)
            
            let similarIntersts : NSMutableString = ""
            if readersData.weightage != nil, let _ = readersData.weightage {
                similarIntersts.append("\(readersData.weightage!)% ")
            }
            similarIntersts.append(localizedTextFor(key: AddFriendRequestReadersText.similarInterest.rawValue))
            similarIntersts.append(" ")
            
            if similarIntersts == ""{
                cell.progressLabel.text = ""
            }else {
                cell.progressLabel.text = similarIntersts as String
            }
            
            if readersData.weightage != nil {
                let progressValueInFloat = Float(readersData.weightage!)
                let progressPerCentage = progressValueInFloat/100
                cell.progressBarView.progress = progressPerCentage
            }else{
                cell.progressBarView.progress = 0
            }
            
            if let friend = readersData.frnd {
                let status = friend.status
                if status == 0{
                    cell.addButton.setTitle(localizedTextFor(key: AddFriendRequestReadersText.Cancel.rawValue), for: .normal)
                    cell.addButton.tag = indexPath.row
                    cell.addButton.removeTarget(self, action: #selector(actionaddButton(_:)), for: .touchUpInside)
                    cell.addButton.addTarget(self, action: #selector(actionCancalButton(_:)), for: .touchUpInside)
                }
                else{
                    
                    cell.addButton.setTitle(localizedTextFor(key: AddFriendRequestReadersText.plusadd.rawValue), for: .normal)
                    cell.addButton.tag = indexPath.row
                    cell.addButton.removeTarget(self, action: #selector(actionCancalButton(_:)), for: .touchUpInside)
                    cell.addButton.addTarget(self, action: #selector(actionaddButton(_:)), for: .touchUpInside)
                }
            }
            else {
                cell.addButton.setTitle(localizedTextFor(key: AddFriendRequestReadersText.plusadd.rawValue), for: .normal)
                
                cell.addButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(actionaddButton(_:)), for: .touchUpInside)
            }
            
            if readersData.categary != nil {
                cell.arrCategory = readersData.categary
                cell.readerCollectionView.reloadData()
            }
        }
        cell.vcObj = self
        return cell
    }
}


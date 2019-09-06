

import UIKit
import CoreData

protocol SearchMyFriendsDisplayLogic: class
{
    func displayGetFriendsList(viewModel: SearchMyFriends.ViewModel)
    
    func displaySendRequsetInfo(viewModel:SearchMyFriends.ViewModel.ReportUser, atIndex: Int)
}

class SearchMyFriendsViewController: UIViewController, SearchMyFriendsDisplayLogic
{
    var interactor: SearchMyFriendsBusinessLogic?
    var router: (NSObjectProtocol & SearchMyFriendsRoutingLogic & SearchMyFriendsDataPassing)?
    
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
        let interactor = SearchMyFriendsInteractor()
        let presenter = SearchMyFriendsPresenter()
        let router = SearchMyFriendsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: View lifecycle
    
    @IBOutlet weak var tblSearchMyFrnd: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblRecentSearch: UILabelFontSize!
    @IBOutlet weak var lblNoDataFound: UILabelFontSize!
    
    var saveFriendArr = [Friends]()
    var isLoading : Bool?
    var isSearching : Bool?
    var label : UILabel?
    var arrfriendList = [SearchMyFriends.ViewModel.userInfo]()
    
    // MARK: viewDidLoad --
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        getSaveFriends()
    }
    
    // MARK: Class Helper --
    func setUpInterface() {
        lblNoDataFound.isHidden = true; CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.SearchMyFriendTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        
        
        tblSearchMyFrnd.tableFooterView = UIView()
        tfSearch.text = ""
        tfSearch.textColor = UIColor.white
        tfSearch.attributedPlaceholder = NSAttributedString(string: localizedTextFor(key: SearchMyFriendText.SearchmyFreind.rawValue),
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
        button.setImage(UIImage(named: localizedTextFor(key: SearchMyFriendText.SearchmyFreind.rawValue)), for: .normal)
        view.addSubview(button)
        tfSearch.leftView = view
        tfSearch.leftViewMode = .always
    }
    
    func searchBookRequest(updatedString: String){
        
        tfSearch.resignFirstResponder()
        let request = SearchMyFriends.Request(query: updatedString)
        interactor?.getFriendList(request: request)
    }
    
    func displayGetFriendsList(viewModel: SearchMyFriends.ViewModel) {
        if viewModel.error != nil {
            // aleart
        }else{
            arrfriendList = viewModel.frindList!
            if arrfriendList.count == 0{
                tblSearchMyFrnd.isHidden = false
            }else{
                tblSearchMyFrnd.isHidden = false
                tblSearchMyFrnd .reloadData()
            }
        }
    }
    
    //MARK:- DisplaySendRequsetInfo --
    func displaySendRequsetInfo(viewModel: SearchMyFriends.ViewModel.ReportUser, atIndex: Int) {
        if viewModel.error != nil {
            
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        } else {
            if saveFriendArr.count != 0 {
                CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
                tblSearchMyFrnd.reloadData()
            }
            
            if arrfriendList.count != 0{
                CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.success!)
                tblSearchMyFrnd.reloadData()
            }
            
        }
    }
    
    func getSaveFriends(){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Friends")
        fetchRequest.returnsObjectsAsFaults = false
        
        //3
        do {
            saveFriendArr = try managedContext.fetch(fetchRequest) as! [Friends]
            print("saveFriendArr",saveFriendArr)
            if  saveFriendArr.count > 0 {
                lblRecentSearch.isHidden = false
                tblSearchMyFrnd.reloadData()
            } else {
                lblRecentSearch.isHidden = true
            }
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveToLocalDataBase(_ readersData: SearchMyFriends.ViewModel.userInfo) {
        
        let arrExist = saveFriendArr.filter() { $0.id == readersData.id!}
        if arrExist.count > 0 {
            return
        }
        
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName:"Friends",
                                       in: managedContext)!
        
        let searchFreinds = NSManagedObject(entity: entity,
                                            insertInto: managedContext)
        
        searchFreinds.setValue(readersData.id,forKey: "id")
        searchFreinds.setValue(readersData.firstname,forKey: "firstname")
        searchFreinds.setValue(readersData.lastname,forKey: "lastname")
        searchFreinds.setValue(readersData.age,forKey: "age")
        searchFreinds.setValue(readersData.gender,forKey: "gender")
        searchFreinds.setValue(readersData.country,forKey: "country")
        searchFreinds.setValue(readersData.state,forKey: "state")
        searchFreinds.setValue(readersData.ffriend_id,forKey: "ffriend_id")
        searchFreinds.setValue(readersData.user_image,forKey: "user_image")
        searchFreinds.setValue(readersData.categary,forKey: "categories")
         searchFreinds.setValue(readersData.weightage,forKey: "weightage")
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            
        }
    }
    
    @objc func actionViewUserProfile(_ sender: UIButton) {
        if sender.tag >= 999999 {
            let index = 999999 - sender.tag
            router?.navigateToUserProfile(withId: "\((saveFriendArr[index].id))")
        } else {
            saveToLocalDataBase(arrfriendList[sender.tag])
            router?.navigateToUserProfile(withId: "\((arrfriendList[sender.tag].id)!)")
        }
    }
    
    
    @objc func actionAddButton(_ sender: UIButton) {
        
        let reqAddFriend = SearchMyFriends.Request.addFriend(ffriend_id: "\((arrfriendList[sender.tag].id)!)",index: sender.tag)
        interactor?.sendFriendRequestApi(request:reqAddFriend)
        
    }
    
    
    @objc func actionAddFriendFromLocal(_ sender: UIButton) {
        
        let reqAddFriend = SearchMyFriends.Request.addFriend(ffriend_id: "\((saveFriendArr[sender.tag].id))",index: sender.tag)
        interactor?.sendFriendRequestApi(request:reqAddFriend)
    }
    
}



extension SearchMyFriendsViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tblSearchMyFrnd {
            if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
                if isLoading == false {
                    isLoading = true
                    tfSearch.text = ""
                    searchBookRequest(updatedString: "")
                }
            }
        }
    }
}


//MARK:- UITexfFeild Delegate

extension SearchMyFriendsViewController: UITextFieldDelegate
{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  (textField.text?.count)! > 0 {
            isSearching = true
            self.searchBookRequest(updatedString: textField.text_Trimmed())
        } else {
            isSearching = false
            arrfriendList.removeAll()
            tblSearchMyFrnd.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
}

// MARK: UITableViewDelegate --
extension SearchMyFriendsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}
// MARK: UITableViewDataSource --
extension SearchMyFriendsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrfriendList.count == 0 {
            return saveFriendArr.count
            
        }else{
            return arrfriendList.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:ViewControllerIds.SearchMyMyfriendsCellIdentifier) as! SearchMyFriendsTableViewCell
        if arrfriendList.count > 0 {
            lblRecentSearch.isHidden = true
            let readersData = arrfriendList[indexPath.row]
            let fullName : NSMutableString = ""
            if readersData.firstname != nil, let _ = readersData.firstname {
                fullName.append((readersData.firstname)!)
                fullName.append(" ")
            }
            if readersData.lastname != nil, let _ = readersData.lastname {
                fullName.append((readersData.lastname)!)
            }
            if fullName == ""{
                cell.lblUserName.text = ""
            }else {
                cell.lblUserName.text = fullName as String
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
                cell.lblAgeGender.text = ""
            }else {
                cell.lblAgeGender.text = ageGender as String
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
                cell.lblLocation.text = ""
            }else {
                cell.lblLocation.text = location as String
            }
            if readersData.user_image != nil, let _ = readersData.user_image {
                cell.btnProfilePic.sd_setImage(with: URL(string: Configurator.imageBaseUrl + readersData.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
            } else {
                cell.btnProfilePic.setImage(UIImage(named: "profile_photo"), for: .normal)
            }
            
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

            cell.btnProfilePic.tag = indexPath.row
            cell.btnProfilePic.addTarget(self, action: #selector(actionViewUserProfile(_:)), for: .touchUpInside)
            
            if readersData.categary != nil {
                cell.arrCategory = readersData.categary!
                cell.categaryColletionVew.reloadData()
            }
            cell.vcObj = self
        }else{
             lblRecentSearch.isHidden = false
            let searchData = saveFriendArr[indexPath.row]
            let fullName : NSMutableString = ""
            if searchData.firstname != nil, let _ = searchData.firstname {
                fullName.append((searchData.firstname)!)
                fullName.append(" ")
            }
            if searchData.lastname != nil, let _ = searchData.lastname {
                fullName.append((searchData.lastname)!)
            }
            if fullName == ""{
                cell.lblUserName.text = ""
            }else {
                cell.lblUserName.text = fullName as String
            }
            let ageGender : NSMutableString = ""
            //            if let _:Int32 = searchData.age {
            ageGender.append("\(searchData.age),")
            ageGender.append(" ")
            //            }
            if searchData.gender != nil, let _ = searchData.gender {
                ageGender.append((searchData.gender)!)
            }
            if ageGender == ""{
                cell.lblAgeGender.text = ""
            }else {
                cell.lblAgeGender.text = ageGender as String
            }
            let location : NSMutableString = ""
            if searchData.state != nil, let _ = searchData.state {
                location.append("\(searchData.state!),")
                location.append(" ")
            }
            if searchData.country != nil, let _ = searchData.country {
                location.append((searchData.country)!)
            }
            if location == ""{
                cell.lblLocation.text = ""
            }else {
                cell.lblLocation.text = location as String
            }
            if searchData.user_image != nil, let _ = searchData.user_image {
                cell.btnProfilePic.sd_setImage(with: URL(string: Configurator.imageBaseUrl + searchData.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
            } else {
                cell.btnProfilePic.setImage(UIImage(named: "profile_photo"), for: .normal)
            }
            
            let similarIntersts : NSMutableString = ""
//            if searchData.weightage != nil, let _ = searchData.weightage {
                similarIntersts.append("\(searchData.weightage)% ")
           // }
            similarIntersts.append(localizedTextFor(key: AddFriendRequestReadersText.similarInterest.rawValue))
            similarIntersts.append(" ")
            
            if similarIntersts == ""{
                cell.progressLabel.text = ""
            }else {
                cell.progressLabel.text = similarIntersts as String
            }
            
            if searchData.weightage == 0 {
                cell.progressBarView.progress = 0
            }else{
                let progressValueInFloat = Float(searchData.weightage)
                let progressPerCentage = progressValueInFloat/100
                cell.progressBarView.progress = progressPerCentage
            }
            
            cell.btnProfilePic.tag = indexPath.row+999999
            cell.btnProfilePic.addTarget(self, action: #selector(actionViewUserProfile(_:)), for: .touchUpInside)
            if searchData.categories != nil {
                cell.arrCategory = searchData.categories! as? [String]
                cell.categaryColletionVew.reloadData()
            }
            cell.vcObj = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

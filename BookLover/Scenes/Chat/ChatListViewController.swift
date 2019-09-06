

import UIKit

protocol ChatListDisplayLogic: class
{
    func displayfriendList(viewModel: ChatList.ViewModel)
}

class ChatListViewController:BaseViewControllerUser, ChatListDisplayLogic
{
    var interactor: ChatListBusinessLogic?
    var router: (NSObjectProtocol & ChatListRoutingLogic & ChatListDataPassing)?
    
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
        let interactor = ChatListInteractor()
        let presenter = ChatListPresenter()
        let router = ChatListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    ////////////////////////////////////////////////////////////
    
    // MARK: Outlet --
    @IBOutlet weak var tblChatList: UITableView!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblNoDataFound: UILabelCustomClass!
    var isSearch: Bool = false
    var arrfriendList = [ChatList.ViewModel.FreindInfo]()
    var arrSearch = [ChatList.ViewModel.FreindInfo]()
    
    // MARK: viewDidLoad --
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: viewWillAppear --
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
        getChatHistoryList()
        tfSearch.resignFirstResponder()
        tfSearch.text = ""
        isSearch = false
        tblChatList.tableFooterView = UIView()
    }
    
    // MARK: Class Helper --
    func setUpInterface() {
        lblNoDataFound.isHidden = true; CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SceneTitleText.ChatSceneTitle.rawValue))
        addSlideMenuButton()
        CustomNavigationItems.sharedInstance.rightBarButton(onVC: self)
        
        
        tblChatList.tableFooterView = UIView()
        tfSearch.text = ""
        tfSearch.textColor = UIColor.white
        tfSearch.addTarget(self, action: #selector(textFeildDidChange(_:)), for: .editingChanged)
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
        button.setImage(UIImage(named: "serch"), for: .normal)
        view.addSubview(button)
        tfSearch.leftView = view
        tfSearch.leftViewMode = .always
    }
    
    @objc func textFeildDidChange(_ textField: UITextField?) {
        
        let strTextTrim = textField?.text?.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if (strTextTrim?.count ?? 0) > 0 {
            isSearch = true
          
            arrSearch = arrfriendList.filter {
                return $0.firstname?.range(of: strTextTrim!, options: .caseInsensitive) != nil
            }
            for (ind, var obj) in  arrSearch.enumerated() {
                obj.isSelected = false
                arrSearch[ind] = obj
            }
            tblChatList.reloadData()
        } else {
            isSearch = false
            tblChatList.reloadData()
        }
    }
    
    func getChatHistoryList()
    {
        interactor?.getChatList()
    }
    
    @objc func actionViewUserProfile(_ sender: UIButton) {
        
        if isSearch == true {
            router?.navigateToUserProfile(withId: "\((arrSearch[sender.tag].id)!)")
        }else{
            router?.navigateToUserProfile(withId: "\((arrfriendList[sender.tag].id)!)")
        }
    }
    
    func displayfriendList(viewModel: ChatList.ViewModel) {
        
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        }else{
            arrfriendList = viewModel.friendList!
            if arrfriendList.count == 0{
                lblNoDataFound.isHidden = false
            }
            tblChatList .reloadData()
        }
    }
}

// MARK: UITableViewDelegate --
extension ChatListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
// MARK: UITableViewDataSource --
extension ChatListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearch.count
        }else{
            return arrfriendList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ViewControllerIds.ChatListCellIndetifier) as! ChatListTableViewCell
        
        if arrfriendList.count > 0 {
            
            var frnddata = ChatList.ViewModel.FreindInfo()
            if isSearch != true {
                frnddata = arrfriendList[indexPath.item]
            }else{
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
            
            if strName == "" {
                cell.lblUserName.text = " "
            } else {
                cell.lblUserName.text = strName as String
            }
            
            cell.btnProfilePic.setImage(UIImage(named: "profile_photo"), for: .normal)
            if frnddata.user_image != nil, let _ = frnddata.user_image {
                
                if frnddata.profile_privacy == 0 {
                    
                    cell.btnProfilePic.sd_setImage(with: URL(string: Configurator.imageBaseUrl + frnddata.user_image!), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
                }
            }
            
            if frnddata.is_read == 0 {
                cell.btnProfilePic.layer.borderColor = appThemeColor.cgColor
            } else {
                cell.btnProfilePic.layer.borderColor = UIColor.white.cgColor
            }
            
            let lastmsg = frnddata.message
            if lastmsg == ""{
                cell.lblLastMessage.text = ""
            }else {
                cell.lblLastMessage.text = lastmsg
            }
            
            let TimestampStr =  frnddata.created
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let messageDate = inputFormatter.date(from: TimestampStr!)
            let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(messageDate!, currentDate: timeStamp.sharedInstance.convertDateToLocal(Date()), numericDates: true)
            printToConsole(item: timeAgo)
            cell.lblMessageTime.text = timeAgo
            
            cell.btnProfilePic.tag = indexPath.row
            cell.btnProfilePic.addTarget(self, action: #selector(actionViewUserProfile(_:)), for: .touchUpInside)
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrfriendList.count > 0 {
            
            var frnddata = ChatList.ViewModel.FreindInfo()
            if isSearch != true {
                frnddata = arrfriendList[indexPath.item]
            }else{
                frnddata = arrSearch[indexPath.item]
            }
            
            let fromUserId = frnddata.id
            
            
            var userImage = ""
            if frnddata.user_image != nil, let _ = frnddata.user_image {
                if frnddata.profile_privacy == 0 {
                  userImage = frnddata.user_image!
                }
            }
            
            let strName : NSMutableString = ""
            if frnddata.firstname != nil, let _ = frnddata.firstname {
                strName.append((frnddata.firstname)!)
                strName.append(" ")
            }
            
            if frnddata.lastname != nil, let _ = frnddata.lastname {
                strName.append((frnddata.lastname)!)
            }
            let fullname:String = strName as String
            router?.navigateToChatScene(from_user_id:fromUserId!,userName:fullname,userImage:userImage)
        }
    }
}

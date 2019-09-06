
import UIKit
import Starscream
import IQKeyboardManagerSwift



protocol ChatDisplayLogic: class
{
    func displayChatHistory(viewModel: Chat.ViewModel )
    func displayGetOtherData(fromUsed:Int,userName:String,userImage:String)
}

let socket = WebSocket(url: URL(string: Configurator.socketUrl)!)

class ChatViewController: UIViewController, ChatDisplayLogic
{
    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic & ChatDataPassing)?
    
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
        let interactor = ChatInteractor()
        let presenter = ChatPresenter()
        let router = ChatRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: View lifecycle
    
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet weak var textviewWriteMessage: GrowingTextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var bottomViewSpace: NSLayoutConstraint!
    
    @IBOutlet weak var viewWriteMessage: UIView!
    @IBOutlet weak var btnProfileImage: UIButton!
    @IBOutlet weak var lblUserName: UILabelFontSize!
    @IBOutlet weak var lbltyping: UILabelFontSize!
    var arrChatHistory = [Chat.ViewModel.ChatMessage]()
    var currentVC: UIViewController?
    var fromId : Int?
    var keyboardHeight : CGFloat?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewWriteMessage.layer.borderWidth = 0.5
        viewWriteMessage.layer.borderColor = UIColor.black.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        socket.delegate = self
        textviewWriteMessage.delegate = self 
        socket.connect()
        setUpInterface()
        getChatHistory()
        interactor?.getOtherUserData()
        //tblChatList.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        interactor?.readMessageStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textviewWriteMessage.resignFirstResponder()
        IQKeyboardManager.shared.enable = true
    }
    
    func setUpInterface() {
        self.navigationController?.isNavigationBarHidden = true
       // keyboardHeight = 0;
        textviewWriteMessage.placeholder = localizedTextFor(key: AddCommentText.WriteMessage.rawValue)
        self.bottomViewSpace.constant = 0
            btnProfileImage.layer.cornerRadius = btnProfileImage.frame.size.height/2.0
            btnProfileImage.clipsToBounds = true
    }
    
    //MARK:-- Request Methods --
    
    func getChatHistory(){
        interactor?.getChatHistory()
    }
    
    
    //MARK:-- Response Methods --

    func displayGetOtherData(fromUsed: Int, userName: String, userImage: String) {
        
        let strImg = Configurator.imageBaseUrl + userImage
        btnProfileImage.sd_setImage(with: URL(string: strImg), for: .normal, placeholderImage: UIImage(named: "profile_photo"))
        
        lblUserName.text = userName
        fromId = fromUsed
        
    }
    
    func displayChatHistory(viewModel: Chat.ViewModel) {
        
        if viewModel.error != nil {
            CustomAlertController.sharedInstance.showErrorAlert(error: viewModel.error!)
        }else{
            arrChatHistory = viewModel.chatHistroy!
            arrChatHistory.reverse()
            //  print(arrChatHistory)
            if arrChatHistory.count == 0{
                
            }
            tblChatList .reloadData()
            scrollToLastRow()
        }
    }
    
    //MARK:-- Class Helpers --
    
    func makeConnection() {
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "from_user_id":userId,
            "type":"connect",
        ]
        // Change json To string
        let str = CommonFunctions.sharedInstance.getJsonString(param!)
        // socket call Message send
        socket.write(string: str) {
            printToConsole(item: "connection established")
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        
        var keyInfo = notification?.userInfo
//        if keyboardHeight == 0 {
            let keyboardFrame = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let fkeyboardHeight = keyboardFrame?.size.height
//        }
        let duration = TimeInterval(Double((keyInfo![UIKeyboardAnimationDurationUserInfoKey] as? CGFloat) ?? 0.0))
        
       // UIView.animate(withDuration: duration, animations: {
            self.bottomViewSpace.constant = -(fkeyboardHeight!)
          //  self.scrollToLastRow()
       // })
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        
        var keyInfo = notification?.userInfo
        
        let duration = TimeInterval(Double((keyInfo![UIKeyboardAnimationDurationUserInfoKey] as? CGFloat) ?? 0.0))
        
        UIView.animate(withDuration: duration, animations: {
            self.bottomViewSpace.constant = 0
        })
    }
    
    
    func decode(_ s: String) -> String? {
        if s.containsEmoji {
            let data = s.data(using: .utf8)!
            return String(data: data, encoding: .nonLossyASCII)
        } else {
            return s
        }
    }
    
    func encode(_ s: String) -> String {
        if s.containsEmoji {
            let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
            return String(data: data, encoding: .utf8)!
        } else {
            return s
        }
    }
    
//    var containsEmoji: Bool {
//
//        for scalar in UnicodeScalar {
//            switch scalar.value {
//            case 0x1F600...0x1F64F, // Emoticons
//            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
//            0x1F680...0x1F6FF, // Transport and Map
//            0x2600...0x26FF,   // Misc symbols
//            0x2700...0x27BF,   // Dingbats
//            0xFE00...0xFE0F,   // Variation Selectors
//            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
//            0x1F1E6...0x1F1FF: // Flags
//                return true
//            default:
//                continue
//            }
//        }
//        return false
//    }
    
    @objc func scrollToLastRow() {
        
        let arrCount: Int = arrChatHistory.count;
        if (arrCount >= 1) {
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrChatHistory.count-1, section: 0)
                self.tblChatList.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    // MARK: ---- Button Selector ----
    
    @IBAction func actionSendMessage(_ sender: Any) {
        let text = textviewWriteMessage.text
        let trimmedText = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText?.isEmpty ?? true {
        }else{
            
           // textviewWriteMessage.resignFirstResponder()
            interactor?.emitSendMessage(message: encode(textviewWriteMessage.text!))
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let myDateString = inputFormatter.string(from: timeStamp.sharedInstance.convertDateToLocal(Date()))
            let MessageStr:String = encode(textviewWriteMessage.text!)
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue)
            let sendMessageDict = Chat.ViewModel.ChatMessage(
                id: nil,
                from_user_id: userId as? Int,
                to_user_id: fromId ,
                message: MessageStr,
                is_read: nil,
                is_from_deleted: nil,
                is_to_deleted: nil,
                created:myDateString
            )
            arrChatHistory.append(sendMessageDict)
            tblChatList.reloadData()
            self.scrollToLastRow()
            textviewWriteMessage.text = ""
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actionProfilepic(_ sender: Any) {
        router?.navigateToUserProfile(withId:("\((fromId)!)"))
    }
}

// MARK: UITableViewDelegate --
extension ChatViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

// MARK: UITableViewDataSource --
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int
        //let userId: Int16 = 303
       // printToConsole(item: arrChatHistory)
        if arrChatHistory.count > 0 {
            let chatHistoryData = arrChatHistory[indexPath.item]
            let fromUsedID = chatHistoryData.from_user_id
            // var toUserId = chatHistoryData.to_user_id
            if userId == fromUsedID  {
                let  cell = tableView.dequeueReusableCell(withIdentifier:ViewControllerIds.SendMessageCellIndetifier) as! SendMessageTableViewCell
                cell.lblSendMessage.text = decode(chatHistoryData.message!)
                
                let TimestampStr =  chatHistoryData.created
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let messageDate = inputFormatter.date(from: TimestampStr!)
                let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(messageDate!, currentDate: timeStamp.sharedInstance.convertDateToLocal(Date()), numericDates: true)
               // printToConsole(item: timeAgo)
                cell.lblSendMessageTym.text = timeAgo
                
                return cell
            } else {
                let  cell = tableView.dequeueReusableCell(withIdentifier:ViewControllerIds.ReceviedMessageCellIndetifier) as! ReceviedMessageTableViewCell
                cell.lblReceviedMessage.text = decode(chatHistoryData.message!)
                let TimestampStr =  chatHistoryData.created
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let messageDate = inputFormatter.date(from: TimestampStr!)
                let timeAgo:String = timeStamp.sharedInstance.timeAgoSinceDate(messageDate!, currentDate: timeStamp.sharedInstance.convertDateToLocal(Date()), numericDates: true)
               // printToConsole(item: timeAgo)
                cell.lblReceviedMessageTym.text = timeAgo
                return cell
            }
        }else {
            return UITableViewCell()
        }
    }
    
    fileprivate func messageReceived(_ message: String, senderName: String) {
        
    }
}

extension ChatViewController : WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        printToConsole(item: "websocketDidConnect")
        makeConnection()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        printToConsole(item: "websocketDidDisconnect")
    }
    
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        printToConsole(item: "websocketDidReceiveMessage")
        // 1
        guard let data = text.data(using: .utf16),
        let jsonData = try? JSONSerialization.jsonObject(with: data),
        let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
            return
        }
        
        if let jsonDicts = jsonData as? [String: Any] {
            if fromId == jsonDicts["from_user_id"] as? Int {
               
                printToConsole(item: jsonDicts)
                let type = jsonDicts["type"]  as? String
                if type == "Message" {
                    
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let myDateString = inputFormatter.string(from: timeStamp.sharedInstance.convertDateToLocal(Date()))
                    let messageDict = Chat.ViewModel.ChatMessage(
                        id: nil,
                        from_user_id: jsonDicts["from_user_id"] as? Int,
                        to_user_id: jsonDicts["to_user_id"] as? Int,
                        message: jsonDicts["message"] as? String,
                        is_read: nil,
                        is_from_deleted: nil,
                        is_to_deleted: nil,
                        created: myDateString
                    )
                    arrChatHistory.append(messageDict)
                    tblChatList.reloadData()
                    self.scrollToLastRow()
                }else if type == "typing" {
                    let status = jsonDicts["status"] as? String
                    if status == "true" {
                        lbltyping.text = localizedTextFor(key: UserProfileText.TypingTitle.rawValue)
                    } else {
                        lbltyping.text = ""
                    }
                }else{
                    return
                }
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        printToConsole(item: "websocketDidReceiveData")
    }
}

extension ChatViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var typingStaus : Bool
        typingStaus = true
        //*-- Emit Typing Socket --*
        let  reqstarttyping = Chat.typingStatus(status: typingStaus)
        interactor?.emitTyping(request: reqstarttyping)
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if(numberOfChars == 0){
            //**-- Emit Stop Typing Socket--**
            typingStaus = false
            let  reqEndtyping = Chat.typingStatus(status: typingStaus)
            interactor?.stopTyping(request: reqEndtyping)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let  reqstarttyping = Chat.typingStatus(status: true)
        interactor?.emitTyping(request: reqstarttyping)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let  reqEndtyping = Chat.typingStatus(status: false)
        interactor?.stopTyping(request: reqEndtyping)
    }
}


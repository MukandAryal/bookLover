

import UIKit

protocol ChatBusinessLogic
{
    func getChatHistory()
    func emitSendMessage(message:String)
    func emitTyping(request:Chat.typingStatus)
    func stopTyping(request:Chat.typingStatus)
    func getOtherUserData()
    func readMessageStatus()
}

protocol ChatDataStore
{
  var from_user_id: Int { get set }
  var userName : String { get set }
  var userImage: String { get set }
}

class ChatInteractor: ChatBusinessLogic, ChatDataStore
{
    var userName: String = ""
    var userImage: String = ""
    var from_user_id: Int = 0
    
  var presenter: ChatPresentationLogic?
  var worker: ChatWorker?
  //var name: String = ""
    
    func getOtherUserData() {
      presenter?.presentGetUserData(fromUsed: from_user_id, userName: userName, userImage: userImage)
    }
    
    func getChatHistory() {
        worker = ChatWorker()
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "user_id":userId,
            "to_user_id":from_user_id
        ]
        worker?.hitChatHistoryApi(parameters:param!, apiResponse: { (response) in
            self.presenter?.presentGetChatHistoryResponse(response: response)
        })
    }
    
    func emitSendMessage(message:String) {
         let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        
        let data = appDelegateObj.userData
        let strName : NSMutableString = ""
        var fullname:String?
        if data["firstname"] as? String != nil, let _ = data["firstname"] as? String {
            strName.append((data["firstname"])! as! String)
            strName.append(" ")
        }
        
        if data["lastname"] != nil, let _ = data["lastname"] {
            strName.append((data["lastname"])! as! String)
        }
        fullname = strName as String
        
        
        var strImg : String = ""
        if data["user_image"] != nil && (data["user_image"] as? String) != nil {
            strImg = data["user_image"] as! String
        }
        
        fullname = strName as String
        
        let userInfo: [String: Any] = ["user_id":data["id"]!,"user_name":fullname!, "user_image": strImg]
        
        let param: [String : Any]?
        param = [
            "from_user_id":userId,
            "to_user_id":from_user_id,
            "message" : message as Any,
            "type":"Message",
            "userInfo":userInfo
        ]

        // Change json To string
        printToConsole(item: param)
        let str = CommonFunctions.sharedInstance.getJsonString(param!)
        // socket call Message send
        socket.write(string: str) {

        }
    }
    
    func emitTyping(request:Chat.typingStatus) {
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "from_user_id":userId,
            "to_user_id":from_user_id,
            "type":"typing",
            "status": "true"
        ]
        // Change json To string
        let str = CommonFunctions.sharedInstance.getJsonString(param!)
        // socket call Message send
        socket.write(string: str) {

        }
    }
    
    func stopTyping(request:Chat.typingStatus) {
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "from_user_id":userId,
            "to_user_id":from_user_id,
            "type":"typing",
            "status": "false"
        ]
        // Change json To string
        let str = CommonFunctions.sharedInstance.getJsonString(param!)
        // socket call Message send
       socket.write(string: str) {
        
        }
    }
  
    
    func readMessageStatus() {
        
        let loggedInId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "from_user_id":loggedInId,
            "to_user_id":from_user_id,
            "type":"read_msg"
        ]
        
        // Change json To string
        let str = CommonFunctions.sharedInstance.getJsonString(param!)
        // socket call Message send
        socket.write(string: str) {
            
        }
    }
}

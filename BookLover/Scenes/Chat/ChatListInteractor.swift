

import UIKit

protocol ChatListBusinessLogic
{
    func getChatList()
    
}

protocol ChatListDataStore
{
  //var name: String { get set }
}

class ChatListInteractor: ChatListBusinessLogic, ChatListDataStore
{
    
  var presenter: ChatListPresentationLogic?
  var worker: ChatListWorker?
  //var name: String = ""
    func getChatList() {
        worker = ChatListWorker()
        let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
        let param: [String : Any]?
        param = [
            "user_id":userId,
        ]
        worker?.hitGetChatListApi(parameters:param!, apiResponse: { (response) in
            printToConsole(item: response)
            self.presenter?.presentGetChatListResponse(response: response)
        })
    }

}

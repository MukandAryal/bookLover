
import UIKit

protocol ChatPresentationLogic
{
  func presentGetChatHistoryResponse(response: ApiResponse)
  func presentGetUserData(fromUsed: Int, userName: String, userImage: String)
}

class ChatPresenter: ChatPresentationLogic
{

  weak var viewController: ChatDisplayLogic?
  
  // MARK: Do something
  
    func presentGetChatHistoryResponse(response: ApiResponse) {
        var model = Chat.ViewModel()
        if response.code == SuccessCode {
            if response.code == SuccessCode {
                let result = response.result as! NSDictionary
                var chatHistoryList = [Chat.ViewModel.ChatMessage]()
                for obj in (result["chats"] as? [[String:Any]])! {
                    let history = Chat.ViewModel.ChatMessage(
                        id: obj["id"] as? Int,
                        from_user_id: obj["from_user_id"] as? Int,
                        to_user_id: obj["to_user_id"] as? Int,
                        message: obj["message"] as? String,
                        is_read: obj["is_read"] as? Int,
                        is_from_deleted: obj["is_from_deleted"] as? Int,
                        is_to_deleted: obj["is_to_deleted"] as? Int,
                        created: obj["created"] as? String
                    )
                    chatHistoryList.append(history)
                }
                model = Chat.ViewModel(chatHistroy: chatHistoryList, error: nil)
            }else{
                model = Chat.ViewModel(chatHistroy: nil, error: response.error)
            }
            viewController?.displayChatHistory(viewModel: model)
        }
    }
    
    func presentGetUserData(fromUsed: Int, userName: String, userImage: String) {
        viewController?.displayGetOtherData(fromUsed: fromUsed, userName: userName, userImage: userImage)
    }

}


import UIKit

enum Chat
  {
    struct Request
    {
        var message : String?
    }
    
    struct typingStatus {
        var status : Bool?
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct ChatMessage {
          var  id: Int?
          var  from_user_id: Int?
          var  to_user_id: Int?
          var  message: String?
          var  is_read: Int?
          var  is_from_deleted: Int?
          var  is_to_deleted: Int?
          var  created: String?
        }
        
        var chatHistroy : [ChatMessage]?
        var error: String?
    }
}

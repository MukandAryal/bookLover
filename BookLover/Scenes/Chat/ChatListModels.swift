
import UIKit

enum ChatList
  {
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct FreindInfo {
            var id: Int?
            var firstname: String?
            var lastname: String?
            var gender: String?
            var city: String?
            var state: String?
            var country: String?
            var age: Int?
            var user_image: String?
            var Frndid: Int?
            var from_user_id: Int?
            var to_user_id: Int?
            var message: String?
            var is_read: Int?
            var is_from_deleted: Int?
            var is_to_deleted: Int?
            var created:String?
            var  isSelected : Bool?
            var profile_privacy: Int?
        }
        
        var friendList : [FreindInfo]?
        var error: String?
    }
}

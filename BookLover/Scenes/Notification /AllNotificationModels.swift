
import UIKit

enum AllNotification
{
    struct Request
    {
        struct acceptRequest {
            var id : String?
            var index: Int?
        }
        
        struct declineRequest {
            var id : String?
            var index: Int?
        }
        
        struct shareNotification {
            var id : Int?
            var  type: String?
            var bookId: Int?
        }
        struct otherNotification {
            var review_id : Int?
            var  type: String?
            var id: String?
        }
    }
    struct Response
    {
    }
    
    struct ViewModel
    {
        struct userInfo {
            var id: Int?
            var  user_id: Int?
            var  nuser_id: Int?
            var  message: String?
            var  book_id:Int?
            var  review_id:Int?
            var  is_read: Int?
            var  type: String?
            var  created: String?
            var nuserid: Int?
            var nuserfirstname: String?
            var nuserlastname: String?
            var nuseruser_image: String?
            var Privacies :PrivaciesInfo?
        }
        
        struct PrivaciesInfo {
            var age : Int?
            var comment : Int?
            var email : Int?
            var follow : Int?
            var gender : Int?
            var id : Int?
            var last_seen : Int?
            var message : Int?
            var profile_pic : Int?
            var user_id : Int?
        }
        
        var notificationInfo: [userInfo]?
        var error: String?
    }
    
  //  struct ViewModel
//    {
//        struct userInfo {
//            var id: Int?
//            var  user_id: Int?
//            var  nuser_id: Int?
//            var  message: String?
//            var  book_id:Int?
//            var  review_id:Int?
//            var  is_read: Int?
//            var  type: String?
//            var  created: String?
//            var nuserid: Int?
//            var nuserfirstname: String?
//            var nuserlastname: String?
//            var nuseruser_image: String?
//            var profile_privacy: Int?
//        }
//        var notificationInfo: [userInfo]?
//        var error: String?
//    }
    
    struct friendRequest {
        
        struct friendRequestUserInfo {
            var id: Int?
            var firstname: String?
            var lastname: String?
            var gender: String?
            var city: String?
            var state: String?
            var country: String?
            var age: Int?
            var user_image: String?
            var categary:[String]?
            var frnd : FriendId?
            var Privacies :PrivaciesInfo?
            
        }
        
        struct FriendId {
            var id: Int?
            var user_id: Int?
            var ffriend_id: Int?
            var status: Int?
            var request_user_id: Int?
            var action_user_id: Int?
            var created_at: String?
            var modified_at:String?
        }
        
        struct PrivaciesInfo {
            var age : Int?
            var comment : Int?
            var email : Int?
            var follow : Int?
            var gender : Int?
            var id : Int?
            var last_seen : Int?
            var message : Int?
            var profile_pic : Int?
            var user_id : Int?
        }
        
        var frindRequestInfo: [friendRequestUserInfo]?
        var error: String?
        
        struct ReportUser {
            var error: String?
            var success: String?
        }
    }
    
   // struct friendRequest
//      {
//        struct friendRequestUserInfo {
//            var id: Int?
//            var firstname: String?
//            var lastname: String?
//            var gender: String?
//            var city: String?
//            var state: String?
//            var country: String?
//            var age: Int?
//            var user_image: String?
//            var categary:[String]?
//            var profile_privacy: Int?
//            var frnd : FriendId?
//
//        }
//        struct FriendId {
//            var id: Int?
//            var user_id: Int?
//            var ffriend_id: Int?
//            var status: Int?
//            var request_user_id: Int?
//            var action_user_id: Int?
//            var created_at: String?
//            var modified_at:String?
//        }
//         var frindRequestInfo: [friendRequestUserInfo]?
//         var error: String?
//
//        struct ReportUser {
//            var error: String?
//            var success: String?
//        }
//    }
}



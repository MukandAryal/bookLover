
import UIKit

enum AddFriend
{
    
    // MARK: Use cases
    struct Request
    {
        struct addFriend {
            var ffriend_id : String?
            var index: Int?
        }
        
        struct cancalRequest {
            var id : String?
            var index: Int?
        }
    }
    struct Response
    {
    }
    
    
    
    struct ViewModel
    {
        struct userInfo {
            var id: Int?
            var firstname: String?
            var lastname: String?
            var gender: String?
            var city: String?
            var state: String?
            var country: String?
            var age: Int?
            var user_image: String?
            var weightage: Int?
            var requestId: Int?
            var categary:[String]?
            var frnd : FriendId?
            var Privacies :PrivaciesInfo?
            
        }
        
        struct FriendId {
            var  id: Int?
            var  user_id: Int?
            var  ffriend_id: Int?
            var  status: Int?
            var  request_user_id: Int?
            var  action_user_id: Int?
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
        
        struct ReportUser {
            var error: String?
            var success: String?
            var requestId: Int?
        }
        
        var frindList: [userInfo]?
        var error: String?
    }
    
//    struct ViewModel
//    {
//        struct userInfo {
//            var id: Int?
//            var firstname: String?
//            var lastname: String?
//            var gender: String?
//            var city: String?
//            var state: String?
//            var country: String?
//            var age: Int?
//            var user_image: String?
//            var weightage: Int?
//            var requestId: Int?
//            var categary:[String]?
//            var frnd : FriendId?
//
//        }
//        struct FriendId {
//            var  id: Int?
//            var  user_id: Int?
//            var  ffriend_id: Int?
//            var  status: Int?
//            var  request_user_id: Int?
//            var  action_user_id: Int?
//        }
//
//        struct ReportUser {
//            var error: String?
//            var success: String?
//            var requestId: Int?
//        }
//
//        var frindList: [userInfo]?
//        var error: String?
//    }
}

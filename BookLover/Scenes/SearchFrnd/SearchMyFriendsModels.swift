 
import UIKit

enum SearchMyFriends
{
    struct Request
    {
        var query : String?
        
        struct addFriend {
            var ffriend_id : String?
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
            var weightage: Int?
            var user_image: String?
            var ffriend_id : Int?
            var categary:[String]?
        }
        
        struct ReportUser {
            var error: String?
            var success: String?
            var requestId: Int?
        }
        
        var frindList: [userInfo]?
        var error: String?
    }
 }

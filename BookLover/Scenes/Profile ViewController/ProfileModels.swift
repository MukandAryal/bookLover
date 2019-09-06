
import UIKit

enum Profile
{
    struct Request
    {
        struct CancelRequest {
            let id : String?
            let status: Int?
        }
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct BlockUser {
            var error: String?
            var success: String?
        }
        
        struct ReportUser {
            var error: String?
            var success: String?
        }
        
        struct UserInfo{
            
            var id: Int?
            var firstname: String?
            var lastname: String?
            var email: String?
            var about: String?
            var gender: String?
            var address: String?
            var city: String?
            var state: String?
            var country: String?
            var zipcode: Int?
            var dob: String?
            var age: Int?
            var last_seen: String?
            var group_id: Int?
            var role_id: Int?
            var created_at: String?
            var modified_at: String?
            var user_image: String?
            var profile_privacy: Int?
            var review_privacy: Int?
            var message_privacy: Int?
            var is_deleted: Bool?
            var updated_at: String?
            var active: Bool?
            var status: Bool?
            var lat: Double?
            var lng: Double?
            var is_logged_in: Bool?
            var social_type: Bool?
            var social_token: Int?
            var otp: Int?
            var token : String?
            var favBooks : Int?
            var pendingBooks : Int?
            var readBooks : Int?
            var readingBooks : Int?
            var totalBooks : Int?
            var viewage : Int?
            var viewcomment : Int?
            var viewemail : Int?
            var viewfollow : Int?
            var viewgender : Int?
            var viewid : Int?
            var viewmessage : Int?
            var viewprofile_pic : Int?
            var viewuser_id : Int?
            var viewLastSeen: Int?
            var favouriteBooks : [FavouriteBooks]?
            var friendData : FriendData?
            
            struct FavouriteBooks {
                
                var author_name : String?
                var cover_photo : String?
                var isbn_no : String?
                var name : String?
                var book_id : Int?
                var id : Int?
                var is_favourite : Int?
                var shelf_status : Int?
            }
            
            struct FriendData {
                var id: Int?
                var user_id: Int?
                var ffriend_id: Int?
                var status: Int?
                var request_user_id: Int?
                var action_user_id: Int?
                var created_at: String?
                var modified_at: String?
            }
            
        }
        var userData : UserInfo?
        var error: String?
    }
}

enum ProfileInfo {
    
    struct Data {
        
        var id: Int?
        var firstname: String?
        var lastname: String?
        var email: String?
        var about: String?
        var gender: String?
        var address: String?
        var city: String?
        var state: String?
        var country: String?
        var zipcode: Int?
        var dob: String?
        var age: Int?
        var last_seen: String?
        var group_id: Int?
        var role_id: Int?
        var created_at: String?
        var modified_at: String?
        var user_image: String?
        var profile_privacy: Int?
        var review_privacy: Int?
        var message_privacy: Int?
        var is_deleted: Bool?
        var updated_at: String?
        var active: Bool?
        var status: Bool?
        var lat: Double?
        var lng: Double?
        var is_logged_in: Bool?
        var social_type: Bool?
        var social_token: Int?
        var otp: Int?
        var token : String?
        var favouriteBooks : Int?
        var pendingBooks : Int?
        var readBooks : Int?
        var readingBooks : Int?
        var totalBooks : Int?
        var viewage : Int?
        var viewcomment : Int?
        var viewemail : Int?
        var viewfollow : Int?
        var viewgender : Int?
        var viewid : Int?
        var viewmessage : Int?
        var viewprofile_pic : Int?
        var viewuser_id : Int?
    }
    
    struct ViewModel {
        var userData : Data?
        var error: String?
    }
}


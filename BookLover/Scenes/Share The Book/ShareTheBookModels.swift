
import UIKit

enum ShareTheBook
{
    struct Request
    {
        var from_user_id : String?
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct FreindInfo {
            var  about : String?
            var  active : Bool?
            var  address : String?
            var  age : String?
            var  city : String?
            var  country : String?
            var  created_at : String?
            var  dob : String?
            var  email : String?
            var  firstname : String?
            var  gender : String?
            var  group_id : String?
            var  id : Int16?
            var  is_deleted : Bool?
            var  is_logged_in : Bool?
            var  last_seen : String?
            var  lastname : String?
            var  lat : Float32?
            var  lng : Float32?
            var  message_privacy : Bool?
            var  modified_at : String?
            var  otp : Int16?
            var  profile_privacy : Bool?
            var  review_privacy : Bool?
            var  role_id : Int16?
            var  social_token : Int16?
            var  social_type : String?
            var  state : String?
            var  status : Bool?
            var  updated_at : String?
            var  user_image : String?
            var  zipcode : Int16?
            var  isSelected : Bool?
        }
//        struct friend {
//            var  id: Int?
//            var  user_id: Int?
//            var  ffriend_id: Int?
//            var  status: Bool?
//            var  request_user_id: Int?
//            var  action_user_id: Int?
//            var  created_at: String?
//            var modified_at: String?
//            var friendData : FreindInfo?
//        }
        var friendList : [FreindInfo]?
        var error: String?
        
        struct ShareTheBook {
            var error: String?
            var message: String?
        }
    }
}

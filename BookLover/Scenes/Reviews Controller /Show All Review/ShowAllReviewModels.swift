
import UIKit

enum ShowAllReview
{
    struct Request
    {
        struct LikeUnlike {
            var reviewId: String?
            var isLike: Bool?
            var index: Int?
        }
    }
    struct Response
    {
    }
    
    struct ViewModel
    {
        struct Privacies {
            var id: Int?
            var user_id: Int?
            var profile_pic: Int?
            var email: Int?
            var age: Int?
            var gender: Int?
            var follow: Int?
            var comment: Int?
            var message: Int?
        }
        
//        struct UserInfo {
//            var  about : String?
//            var  active : Bool?
//            var  address : String?
//            var  age : String?
//            var  city : String?
//            var  country : String?
//            var  created_at : String?
//            var  dob : String?
//            var  email : String?
//            var  firstname : String?
//            var  gender : String?
//            var  group_id : String?
//            var  id : Int16?
//            var  is_deleted : Bool?
//            var  is_logged_in : Bool?
//            var  last_seen : String?
//            var  lastname : String?
//            var  lat : Float32?
//            var  lng : Float32?
//            var  message_privacy : Bool?
//            var  modified_at : String?
//            var  otp : Int16?
//            var  profile_privacy : Bool?
//            var  review_privacy : Bool?
//            var  role_id : Int16?
//            var  social_token : Int16?
//            var  social_type : String?
//            var  state : String?
//            var  status : Bool?
//            var  updated_at : String?
//            var  user_image : String?
//            var  zipcode : Int16?
//            var  privacies : [Privacies]?
//        }
        
        struct Review {
            var  book_id : Int16?
            var  commentCount : Int?
            var  created_at : String?
            var  description : String?
            var  id : Int16?
            var  is_deleted : Bool?
            var  is_like : Bool?
            var  likeCount : Int?
            var  rating : Double?
            var  status : Bool?
            var  updated_at : String?
            var  user : ProfileInfo.Data?
        }

        var reviewAllList : [Review]?
        var error: String?
    }
    
    struct LikeUnlikeModel {
        var error : String?
        var success : String?
    }
}

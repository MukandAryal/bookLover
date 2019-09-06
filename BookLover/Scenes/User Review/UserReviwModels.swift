
import UIKit

enum UserReviw
{
    struct Request
    {
    }
    struct Response
    {
    }
    struct ViewModel
    {
        
        struct DeleteReview {
            var error: String?
            var success: String?
        }
        
        struct Review {
            
            var id: Int?
            var user_id: Int?
            var book_id: Int?
            var description: String?
            var rating: Double?
            var status: Bool?
            var is_deleted: Bool?
            var created_at: String?
            var updated_at: String?
            var likeCount: Int?
            var  is_like : Bool?
            var commentCount: Int?
            var comment: [Comments]?
            var user: ProfileInfo.Data?
            
            struct Comments {
                
                var id: Int?
                var review_id: Int?
                var user_id: Int?
                var description: String?
                var created: String?
                var user: ProfileInfo.Data?
            }
        }
        
        var reviewData : Review?
        var error: String?
    }
}

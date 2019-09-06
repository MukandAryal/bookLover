

import UIKit

enum AllBooks
{
    // MARK: Use cases
    struct Request
    {
        var query: String?
        var page : Int?
    }
    struct Response
    {
    }
    
    struct ViewModel
    {
        struct allBooks {
            
            var id:Int?
            var name: String?
            var isbn_no: String?
            var category_id: Int?
            var author_name: String?
            var pages: Int?
            var description: String?
            var cover_photo: String?
            var publisher_name: String?
            var country: String?
            var is_deleted: Bool?
            var created: String?
            var rating: Double?
            var review_count: Int?
            var reviews: [Reviews]?
            var shelves: [Shelves]?
            
            struct Reviews {
                var book_id: Int?
                var rating: Double?
                var count: Int?
            }
            
            struct Shelves {
                var id: Int?
                var user_id: Int?
                var book_id: Int?
                var shelf_status: Int?
                var is_favourite: Bool?
            }
        }
        
        var totalPages : Int?
        var booksList : [allBooks]?
        var error: String?
    }
}

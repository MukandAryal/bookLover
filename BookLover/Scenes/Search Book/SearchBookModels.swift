
import UIKit

enum SearchBook
{
    struct Request
    {
        struct searchTextRequest {
            var updatedSearchString: String?
            var page: Int?
        }
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct searchBook {
            var author_name : String?
            var category_id : Int16?
            var country : String?
            var cover_photo : String?
            var created : String?
            var description : String?
            var id : Int16?
            var is_deleted : Bool?
            var isbn_no : String?
            var name : String?
            var pages : Int?
            var publisher_name : String?
            var rating : Bool?
            var review_count : Int?
        }
        var searchbooksList : [searchBook]?
        var error: String?
    }
}

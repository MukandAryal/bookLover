
import UIKit

enum ShelfType
{
    // MARK: Use cases
    struct Request
    {
        var shelf_status:Int
    }
    struct Response
    {
    }
    struct ViewModel
    {
        struct CellData {
            var cover_photo:String?
            var review_count:Int?
            var name: String?
            var author_name: String?
            var rating:Double?
            var is_favourite:Bool
            var id:Int?
            var bookId:Int?
            var shelf_status:Int?
        }
        
        var collectionArray: [CellData]
    }
}

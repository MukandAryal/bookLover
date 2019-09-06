

import UIKit

protocol AllBooksPresentationLogic
{
    func allBookResonse(response : ApiResponse)
}

class AllBooksPresenter: AllBooksPresentationLogic
{
    weak var viewController: AllBooksDisplayLogic?
    func allBookResonse(response: ApiResponse) {
        var model = AllBooks.ViewModel()
        if response.code == SuccessCode {
            
            var bookList = [AllBooks.ViewModel.allBooks]()
            
            let result = response.result as! NSDictionary
            
            for rbObj in (result["books"] as? [[String:Any]])! {
                
                var review = [AllBooks.ViewModel.allBooks.Reviews]()
                var shelfList = [AllBooks.ViewModel.allBooks.Shelves]()
                
                if rbObj["shelves"] != nil {
                    
                    for shelfObj in (rbObj["shelves"] as? [[String:Any]])! {
                        
                        let shelf = AllBooks.ViewModel.allBooks.Shelves(
                            id: shelfObj["id"] as? Int,
                            user_id: shelfObj["user_id"] as? Int,
                            book_id: shelfObj["book_id"] as? Int,
                            shelf_status: shelfObj["shelf_status"] as? Int,
                            is_favourite: shelfObj["is_favourite"] as? Bool)
                        
                        shelfList.append(shelf)
                    }
                }
                
                
                for revObj in (rbObj["reviews"] as? [[String:Any]])! {
                    let revModel = AllBooks.ViewModel.allBooks.Reviews(
                        book_id: revObj["book_id"] as? Int,
                        rating: revObj["rating"] as? Double,
                        count: revObj["count"] as? Int)
                    review.append(revModel)
                }
                
                let rbModel = AllBooks.ViewModel.allBooks(
                    
                    id: rbObj["id"] as? Int,
                    name: rbObj["name"] as? String,
                    isbn_no: rbObj["isbn_no"] as? String,
                    category_id: rbObj["category_id"] as? Int,
                    author_name: rbObj["author_name"] as? String,
                    pages: rbObj["pages"] as? Int,
                    description: rbObj["description"] as? String,
                    cover_photo: rbObj["cover_photo"] as? String,
                    publisher_name: rbObj["publisher_name"] as? String,
                    country: rbObj["country"] as? String,
                    is_deleted: rbObj["is_deleted"] as? Bool,
                    created: rbObj["created"] as? String,
                    rating: rbObj["rating"] as? Double,
                    review_count: rbObj["review_count"] as? Int,
                    reviews: review,
                    shelves: shelfList)
                
                bookList.append(rbModel)
            }
            model = AllBooks.ViewModel(totalPages : nil, booksList: bookList, error: nil)
        } else {
            model = AllBooks.ViewModel(totalPages : nil, booksList: nil, error: response.error)
        }
        viewController?.displayAllBook(viewModel:model)
    }
}

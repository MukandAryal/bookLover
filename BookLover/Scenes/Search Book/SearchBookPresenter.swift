
import UIKit

protocol SearchBookPresentationLogic
{
    func searchBookResponse(response:ApiResponse)
}

class SearchBookPresenter: SearchBookPresentationLogic
{
    weak var viewController: SearchBookDisplayLogic?
    func searchBookResponse(response: ApiResponse) {
        var model = SearchBook.ViewModel()
        if response.code == SuccessCode  {
            var searchbookList = [SearchBook.ViewModel.searchBook]()
            let result = response.result as? NSDictionary
            for bookObj in (result!["books"] as? [[String:Any]])!{
                let searchBookModel = SearchBook.ViewModel.searchBook(
                    author_name: bookObj["author_name"] as? String,
                    category_id: bookObj["category_id"] as? Int16,
                    country: bookObj["country"] as? String,
                    cover_photo: bookObj["cover_photo"] as? String,
                    created: bookObj["created"] as? String,
                    description: bookObj["description"] as? String,
                    id: bookObj["id"] as? Int16,
                    is_deleted: bookObj["is_deleted"] as? Bool,
                    isbn_no: bookObj["isbn_no"] as? String,
                    name: bookObj["name"] as? String,
                    pages: bookObj["pages"] as? Int,
                    publisher_name: bookObj["publisher_name"] as? String,
                    rating: bookObj["rating"] as? Bool,
                    review_count: bookObj["review_count"] as? Int)
                    searchbookList.append(searchBookModel)
            }
            model = SearchBook.ViewModel(searchbooksList: searchbookList, error: nil)
        } else {
            model = SearchBook.ViewModel(searchbooksList: nil, error: response.error)
        }
        viewController?.displaySearchBook(viewModel:model)
    }
}

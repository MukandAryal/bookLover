
import UIKit

protocol ShelfTypePresentationLogic
{
   func presentApiResponse(response: ApiResponse)
}

class ShelfTypePresenter: ShelfTypePresentationLogic
{
  weak var viewController: ShelfTypeDisplayLogic?
    func presentApiResponse(response: ApiResponse) {
        var bookInfoArray = [ShelfType.ViewModel.CellData]()
        var ViewModelObj:ShelfType.ViewModel
        
        let resultDict = response.result as! NSDictionary
        
        let bookArray = resultDict["books"] as! NSArray
        for arrData in bookArray {
            let bookDict = arrData as! NSDictionary
            let dataDict = bookDict["book"] as! NSDictionary
            
            let obj = ShelfType.ViewModel.CellData(cover_photo: dataDict["cover_photo"] as? String, review_count: dataDict["review_count"] as? Int, name: dataDict["name"] as? String, author_name: dataDict["author_name"] as? String, rating: dataDict["rating"] as? Double, is_favourite: (bookDict["is_favourite"] as? Bool)!, id: bookDict["id"] as? Int, bookId: bookDict["book_id"] as? Int, shelf_status: bookDict["shelf_status"] as? Int)
            
            bookInfoArray.append(obj)
            
        }
        ViewModelObj = ShelfType.ViewModel(collectionArray: bookInfoArray)
        viewController?.displayShelfTypeResponse(viewModel: ViewModelObj)
 
    }
}

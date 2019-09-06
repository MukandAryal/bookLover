
import UIKit

protocol AllBooksBusinessLogic
{
    func getAllBookData(request: AllBooks.Request)
}

protocol AllBooksDataStore
{
    var navTitle: String? { get set }
    var categoryId: String? { get set }
    var OrderNo: String? { get set }
}

class AllBooksInteractor: AllBooksBusinessLogic, AllBooksDataStore
{
    var categoryId: String?
    var navTitle: String?
    var OrderNo: String?
    
    var presenter: AllBooksPresentationLogic?
    var worker: AllBooksWorker?
    
    func getAllBookData(request: AllBooks.Request) {
        
        var param:[String:Any] = ["query":request.query!, "page":request.page!]
        if categoryId != nil {
            param.updateValue(categoryId!, forKey: "category_id")
        } else {
            param.updateValue(OrderNo!, forKey: "order")
        }
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
           param.updateValue(CommonFunctions.sharedInstance.getUserId(), forKey: "user_id")
        }
        
        worker = AllBooksWorker()
        worker?.hitAllBookApi(params: param, apiResponse: { (response) in
            self.presenter?.allBookResonse(response:response)
        })
    }
}

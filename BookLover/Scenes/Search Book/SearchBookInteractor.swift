
import UIKit

protocol SearchBookBusinessLogic
{
    func getSearchBookData(request: SearchBook.Request.searchTextRequest)
}

protocol SearchBookDataStore
{
    //var name: String { get set }
}

class SearchBookInteractor: SearchBookBusinessLogic, SearchBookDataStore
{
    var presenter: SearchBookPresentationLogic?
    var worker: SearchBookWorker?
    
    func getSearchBookData(request: SearchBook.Request.searchTextRequest) {
        worker = SearchBookWorker()
        worker?.hitApiSeachBook(request: request, apiResponse: { (response) in
            self.presenter?.searchBookResponse(response: response)
        })
    }
}

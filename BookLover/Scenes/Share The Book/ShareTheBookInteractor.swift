
import UIKit

protocol ShareTheBookBusinessLogic
{
    func getFriendList()
    func shareApiRequest(request : ShareTheBook.Request)
}

protocol ShareTheBookDataStore
{
    var bookId: String? { get set }
}

class ShareTheBookInteractor: ShareTheBookBusinessLogic, ShareTheBookDataStore
{
    var presenter: ShareTheBookPresentationLogic?
    var worker: ShareTheBookWorker?
    var bookId: String?
    
    func getFriendList() {
        worker = ShareTheBookWorker()
        worker?.hitFriendsListApi(apiResponse: { (response) in
            self.presenter?.getFriendsListResponse(response: response)
        })
    }
    
    
    func shareApiRequest(request: ShareTheBook.Request) {
        
        if isValidRequest(request: request) {
            
            worker = ShareTheBookWorker()
            if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
                let param: [String : Any] = [
                    "to_user_id" : request.from_user_id!,
                    "from_user_id":Int(CommonFunctions.sharedInstance.getUserId())!,
                    "book_id":Int(bookId!)!,
                    ]
                
                worker?.hitShareTheBookApi(parameters: param, apiResponse: { (response) in
                    self.presenter?.presentShareTheBookResponse(response: response)
                    
                })
            }
        }
    }
    
    func isValidRequest(request: ShareTheBook.Request) -> Bool {
        
        var isValid = true
        let validator = Validator()
        if !validator.requiredValidation(request.from_user_id! as String, errorKey: "Paylaşmak için bir kitap seçmelisin.") {
            isValid = false
        }
        return isValid
    }
}


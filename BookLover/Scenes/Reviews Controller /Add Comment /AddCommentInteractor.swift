
import UIKit

protocol AddCommentBusinessLogic
{
    func addCommentApi(request: AddComment.Request)
}

protocol AddCommentDataStore
{
    var reviewId : String? { get set }
}

class AddCommentInteractor: AddCommentBusinessLogic, AddCommentDataStore
{
    var presenter: AddCommentPresentationLogic?
    var worker: AddCommentWorker?
    
    var reviewId : String? 
    
    func addCommentApi(request: AddComment.Request) {
        
        if isValidRequest(request: request) {
            
            worker = AddCommentWorker()
            
            let param: [String : Any] = [
                "description":request.description!,
                "review_id":reviewId!,
                "user_id": CommonFunctions.sharedInstance.getUserId()
            ]
            
            worker?.hitAddCommntApi(parameters: param, apiResponse: { (response) in
                self.presenter?.presentAddCommentResponse(response: response)
            })
        }
    }
    
    func isValidRequest(request: AddComment.Request) -> Bool {
        
        var isValid = true
        let validator = Validator()
        if !validator.requiredValidation(request.description!, errorKey: localizedTextFor(key: RatingvalidationText.writeComment.rawValue)) {
            isValid = false
        }
        return isValid
    }
}


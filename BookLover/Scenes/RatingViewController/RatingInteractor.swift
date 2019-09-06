
import UIKit

protocol RatingBusinessLogic
{
    func writeRatingApi(request: Rating.Request)
    func editWriteRatingApi(request: Rating.Request)
    func getReviewData()
}

protocol RatingDataStore
{
    var bookId: String? { get set }
    var rating: Double? { get set }
    var description: String? { get set }
    var isRatingEdit: Bool? { get set }
}

class RatingInteractor: RatingBusinessLogic, RatingDataStore
{
    
    var presenter: RatingPresentationLogic?
    var worker: RatingWorker?
    var bookId: String?
    var rating: Double?
    var description: String?
    var isRatingEdit: Bool?
    
    
    func writeRatingApi(request: Rating.Request) {
        
        worker = RatingWorker()
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            
            if isValidRequest(request: request) {
                
                let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
                let param: [String : Any] = [
                    "rating" : request.rating!,
                    "description":request.description!,
                    "book_id":bookId!,
                    "user_id": userId
                ]
                
                worker?.hitWriteRatingApi(parameters:param, apiResponse: { (response) in
                    self.presenter?.presentWriteRatingResponse(response: response)
                    
                })
            }
        }
    }
    
    func isValidRequest(request: Rating.Request) -> Bool {
        
        var isValid = true
//        let validator = Validator()
        let rating:Int = Int(Double(request.rating!)!)
        if rating <= 0 {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: RatingvalidationText.writeRating.rawValue))
            isValid = false
        }
        
//        if !validator.requiredValidation(request.description!, errorKey: localizedTextFor(key: RatingvalidationText.writeDescription.rawValue)) {
//            isValid = false
//        }
        return isValid
    }
    
    
    func getReviewData() {
        if rating != nil && description != "" {
            self.presenter?.presentReviewData(rating: rating!, description: description!, isRatingEdit: isRatingEdit!)
        }
    }
    
    func editWriteRatingApi(request: Rating.Request) {
        
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any] = [
                "rating" : request.rating!,
                "description":request.description!,
                "id":bookId!,
            ]
        
            worker = RatingWorker()
            worker?.hitEditWriteRatingApi(parameters: param, apiResponse: { (response) in
                self.presenter?.presentWriteRatingResponse(response: response)
            })
            
    }
}


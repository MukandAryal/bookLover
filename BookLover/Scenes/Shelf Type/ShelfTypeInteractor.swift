
import UIKit

protocol ShelfTypeBusinessLogic
{
    func getShelfTypeApi()
}

protocol ShelfTypeDataStore
{
    var shelfStatus: Int? { get set }
    var navTitle: String? { get set }
    var userId : String? { get set }
}

class ShelfTypeInteractor: ShelfTypeBusinessLogic, ShelfTypeDataStore
{
    var userId: String?
    var presenter: ShelfTypePresentationLogic?
    var worker: ShelfTypeWorker?
    var shelfStatus: Int?
    var navTitle: String?
    
    func getShelfTypeApi()
    {
        var parameters: [String : Any] = ["user_id":userId!]
        
        if shelfStatus! >= 3 {
            parameters.updateValue(true, forKey: "is_favourite")
        } else {
            parameters.updateValue(shelfStatus!, forKey: "shelf_status")
        }
        
        worker = ShelfTypeWorker()
        worker?.hitShelfTypeApi(params: parameters, apiResponse: { (response) in
            printToConsole(item: response)
            if response.code == SuccessCode {
                self.presenter?.presentApiResponse(response: response)
            }
            else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        })

    }
}

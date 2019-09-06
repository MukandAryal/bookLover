
import UIKit

protocol DeleteAccountBusinessLogic
{
    func deleteAccountApi()
}

protocol DeleteAccountDataStore
{
    //var name: String { get set }
}

class DeleteAccountInteractor: DeleteAccountBusinessLogic, DeleteAccountDataStore
{
    var presenter: DeleteAccountPresentationLogic?
    var worker: DeleteAccountWorker?
    
    func deleteAccountApi() {
        worker = DeleteAccountWorker()
        worker?.hitDeleteAccountApi(apiResponse: { (response) in
         self.presenter?.presentDeleteAccountResponse(response: response)
        })
    }
    
    
}

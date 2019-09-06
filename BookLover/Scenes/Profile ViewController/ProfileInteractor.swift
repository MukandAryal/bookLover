
import UIKit

protocol ProfileBusinessLogic
{
    func getUserProfileApi()
    func blockUserApi(withId: String)
    func reportUserApi(withId: String)
   // func getReaderData()
    func sendFriendRequestAPI()
func cancelFriendRequestAPI(request: Profile.Request.CancelRequest)
}

protocol ProfileDataStore
{
    //var name: String { get set }
    var userId : String? { get set }
    var isFromSideMenu: Bool? { get set }
   // var readerData: ProfileInfo.Data? { get set }
}

class ProfileInteractor: ProfileBusinessLogic, ProfileDataStore
{
    var presenter: ProfilePresentationLogic?
    var worker: ProfileWorker?
    var userId : String?
    var isFromSideMenu : Bool?
   // var readerData: ProfileInfo.Data?

    func getUserProfileApi() {
        worker = ProfileWorker()
        worker?.hitGerUserProfileApi(withId: userId!, apiResponse: { (response) in
        self.presenter?.presentGetUserProfileResponse(response: response)
            printToConsole(item: "Reach at interactor")

        })
    }
    
    func blockUserApi(withId: String) {
        let param:[String:Any] = [
            "user_id":Int(CommonFunctions.sharedInstance.getUserId())!,
            "ffriend_id": Int(withId)!]
        worker = ProfileWorker()
        worker?.hitBlockUserApi(param: param, apiResponse: { (response) in
            self.presenter?.presentBlockUserResponse(response: response)
        })
    }
    
    func reportUserApi(withId: String) {
        let param:[String:Any] = [
            "reported_by_id":Int(CommonFunctions.sharedInstance.getUserId())!,
            "reported_user_id": Int(withId)!,
            "reason":"fsgs",
            "description":"th dfhu"]
        worker = ProfileWorker()
        worker?.hitReportUserApi(param: param, apiResponse: { (response) in
            self.presenter?.presentReportUserResponse(response: response)
        })
    }
    
    func sendFriendRequestAPI() {
        worker = ProfileWorker()
        let param: [String:Any] = ["user_id":Int(CommonFunctions.sharedInstance.getUserId())!, "ffriend_id":Int(userId!)!]
        worker?.hitFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentSendFriendRequestResponse(response: response)
        })
    }
    
    func cancelFriendRequestAPI(request: Profile.Request.CancelRequest) {
        
        worker = ProfileWorker()
        let param: [String:Any] = ["action_user_id":Int(CommonFunctions.sharedInstance.getUserId())!, "id":Int(request.id!)!, "status":request.status!]
        worker?.hitCancelFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentCancelFriendRequestResponse(response: response)
        })
    }
}

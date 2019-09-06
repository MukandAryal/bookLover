
import UIKit

protocol AllNotificationBusinessLogic
{
    func allNotification()
    func allFriendRequest()
    func acceptFriendRequestApi(request: AllNotification.Request.acceptRequest)
    func declineFriendRequestApi(request: AllNotification.Request.declineRequest)
    func shareBookNotificationRedirect(request:AllNotification.Request.shareNotification)
    func otherBookNotificationRedirect(request:AllNotification.Request.otherNotification)
}

protocol AllNotificationDataStore
{
    //var name: String { get set }
}

class AllNotificationInteractor: AllNotificationBusinessLogic, AllNotificationDataStore
{
    
    var presenter: AllNotificationPresentationLogic?
    var worker: AllNotificationWorker?
    
    func allNotification() {
        worker = AllNotificationWorker()
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any]?
            param = [
                "user_id":userId,
            ]
            worker?.hitGetNotificationApi(parameters:param!, apiResponse: { (response) in
                printToConsole(item: response)
                self.presenter?.presentGetNotificationResponse(response: response)
            })
    }
    
    func allFriendRequest() {
        worker = AllNotificationWorker()
        worker?.hitGetFriendsRequestApi(apiResponse: { (response) in
            printToConsole(item: response)
            self.presenter?.presentGetFriendRequestResponse(response: response)
        })
    }
    
    func acceptFriendRequestApi(request: AllNotification.Request.acceptRequest) {
        worker = AllNotificationWorker()
        let param: [String:Any] = ["action_user_id":CommonFunctions.sharedInstance.getUserId(), "id":request.id!,
            "status":1]
        worker?.hitAcceptFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentAcceptFriendRequestResponse(response: response, atIndex: request.index!)
        })
    }
    
    func declineFriendRequestApi(request: AllNotification.Request.declineRequest) {
        worker = AllNotificationWorker()
        let param: [String:Any] = ["action_user_id":CommonFunctions.sharedInstance.getUserId(), "id":request.id!,
            "status":2]
        worker?.hitDeclineFriendRequsetApi(param: param, apiResponse: { (response) in
            self.presenter?.presentDeclineFriendRequestResponse(response: response, atIndex: request.index!)
        })
        
    }
    
    func shareBookNotificationRedirect(request: AllNotification.Request.shareNotification) {
        worker = AllNotificationWorker()
        let param: [String:Any] = ["user_id":Int(CommonFunctions.sharedInstance.getUserId())!,
            "id":request.id!,
            "type":request.type!,
            "review_id":request.bookId!
            ]
        worker?.hitShareBookNotificationRedirectApi(param: param, apiResponse: { (response) in
            self.presenter?.presentRedirectNotificationResponse(response: response)
        })
    }
    
    func otherBookNotificationRedirect(request: AllNotification.Request.otherNotification) {
        worker = AllNotificationWorker()
        let param: [String:Any] = ["user_id":CommonFunctions.sharedInstance.getUserId(),
                                   "id":request.id!,
                                   "type":request.type!,
                                   "review_id":request.review_id!]
        worker?.hitOtherNotificationRedirectApi(param: param, apiResponse: { (response) in
            self.presenter?.presentOtherRedirectNotificationResponse(response: response)
        })
    }
}

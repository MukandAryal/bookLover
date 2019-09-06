
import UIKit

protocol MyFriendsBusinessLogic
{
    func getFriendList()
}

protocol MyFriendsDataStore
{
    //var name: String { get set }
}

class MyFriendsInteractor: MyFriendsBusinessLogic, MyFriendsDataStore
{
    var presenter: MyFriendsPresentationLogic?
    var worker: MyFriendsWorker?
    func getFriendList() {
        worker = MyFriendsWorker()
        worker?.hitFriendsListApi(apiResponse: { (response) in
            self.presenter?.presentgetFriendsListResponse(response: response)
        })
    }
}

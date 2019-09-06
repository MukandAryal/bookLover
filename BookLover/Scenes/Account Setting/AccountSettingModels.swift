
import UIKit

enum AccountSetting
  {
    struct Request
    {
        var email : String? 
    }
    struct Response
    {
    }
    struct ViewModel
    {
        var error: String?
        var message: String?
    }
}

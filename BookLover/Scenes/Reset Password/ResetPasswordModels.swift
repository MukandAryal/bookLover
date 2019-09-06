
import UIKit

enum ResetPassword
{
    struct Request
    {
        var oldpassword : String?
        var password : String?
        var confirmPassword : String?
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

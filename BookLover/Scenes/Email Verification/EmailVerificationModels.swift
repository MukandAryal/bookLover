
import UIKit

enum EmailVerification
{
    struct Request
    {
        var otp : Int?
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

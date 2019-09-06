
import UIKit

protocol EmailVerificationBusinessLogic
{
    func emailVerficationApi(request:EmailVerification.Request)
    func resendOtpApi()
}

protocol EmailVerificationDataStore
{
    var IsVerify: Bool? { get set }
}

class EmailVerificationInteractor: EmailVerificationBusinessLogic, EmailVerificationDataStore
{
    var IsVerify: Bool?
    var presenter: EmailVerificationPresentationLogic?
    var worker: EmailVerificationWorker?
    func emailVerficationApi(request:EmailVerification.Request){
        // if isValidRequest(request: request) {
        worker = EmailVerificationWorker()
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any] = [
                "otp":request.otp!,
                "user_id": userId
            ]
            worker?.hitVerifyOtpApi(parameters: param, apiResponse: { (response) in
                self.presenter?.presentEmailVerficationResponse(response: response)
            })
        }
    }
    
    func resendOtpApi() {
        worker = EmailVerificationWorker()
        if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
            let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
            let param: [String : Any] = [
                "user_id": userId
            ]
            worker?.hitOptSendApi(parameters:param, apiResponse: { (response) in
                self.presenter?.presentSendOtpResponse(response: response)
            })
        }
    }
}

func isValidRequest(request: EmailVerification.Request) -> Bool {
    var isValid = true
    let validator = Validator()
    if(request.otp!<4){
//CommonFunctions.sharedInstance.showLoginAlert(referenceController: localizedTextFor(key: EmailVerificationValidationText.otpTitle.rawValue))
    }
    return isValid
}


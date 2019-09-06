
import UIKit

protocol AccountSettingBusinessLogic
{
    func sendOtpApi()
    func changeEmailApi(request:AccountSetting.Request)
    func presentVerifyBool()
    func deleteAccountApi()
}

protocol AccountSettingDataStore
{
    var Isverify: Bool? { get set }
}

class AccountSettingInteractor: AccountSettingBusinessLogic, AccountSettingDataStore
{
    var Isverify: Bool?
    var presenter: AccountSettingPresentationLogic?
    var worker: AccountSettingWorker?
    
    func sendOtpApi() {
        worker = AccountSettingWorker()
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
    
    
    func deleteAccountApi() {
        
        worker = AccountSettingWorker()
        worker?.hitDeleteAccountApi(apiResponse: { (response) in
            self.presenter?.presentDeleteAccountResponse(response: response)
        })
    }
    
    func presentVerifyBool() {
        if Isverify != nil{
            self.presenter?.PresenterIsVerify(isverify:Isverify!)
        }
    }
    
    func changeEmailApi(request: AccountSetting.Request) {
        if isValidRequest(request: request) {
            worker = AccountSettingWorker()
            if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
                let UserId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
                let param: [String : Any] = [
                    "user_id" : UserId,
                    "email"   : request.email!
                ]
                worker?.hitChangeEmailApi(parameters: param, apiResponse: { (response) in
                    self.presenter?.presetChangeEmailResponse(response: response)
                })
            }
        }
    }
    
    func isValidRequest(request: AccountSetting.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if !validator.requiredValidation(request.email!, errorKey: localizedTextFor(key: ValidationsText.emptyEmail.rawValue)) {
            isValid = false
        } else if !validator.emailValidation(request.email!, errorKey: localizedTextFor(key: GeneralValidations.InvalidEmailKey.rawValue)) {
            isValid = false
        } else if appDelegateObj.userData["email"] as? String == request.email! {
             CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: GeneralValidations.MismatchEmailKey.rawValue)))
             isValid = false
        }
       //
        return isValid
    }
    
}

//
//  ResetPasswordInteractor.swift

import UIKit

protocol ResetPasswordBusinessLogic
{
  func resetPasswordApi(request: ResetPassword.Request)
}

protocol ResetPasswordDataStore
{
  //var name: String { get set }
}

class ResetPasswordInteractor: ResetPasswordBusinessLogic, ResetPasswordDataStore
{
    var presenter: ResetPasswordPresentationLogic?
    var worker: ResetPasswordWorker?
    func resetPasswordApi(request: ResetPassword.Request) {
        if isValidRequest(request: request) {
            worker = ResetPasswordWorker()
            if CommonFunctions.sharedInstance.isUserLoggedIn() == true {
                let userId = userDefault.value(forKeyPath: userDefualtKeys.user_Id.rawValue) as! Int16
                let param: [String : Any] = [
                    "user_id": userId,
                    "oldpassword":request.oldpassword != nil ? request.oldpassword! : "",
                    "password":request.password!,
                    "confirmPassword":request.confirmPassword!
                ]
                printToConsole(item: param)
                worker?.hitApiResetPassword(parameters: param, apiResponse: { (response) in
                    self.presenter?.presentResetPasswordResponse(response: response)
                })
            }
        }
    }
    
    func isValidRequest(request: ResetPassword.Request) -> Bool {
        var isValid = true
        let validator = Validator()
        if request.oldpassword != nil && !validator.requiredValidation(request.oldpassword!, errorKey: localizedTextFor(key:GeneralValidations.OldPasswordKey.rawValue)) {
            isValid = false
            
        } else if !validator.requiredValidation(request.password!, errorKey: localizedTextFor(key: GeneralValidations.EnterPasswordKey.rawValue)) {
            self.presenter?.presentWrongPassword(confirmPassword:true)
            isValid = false
            
        }
//        else if !validator.stringLengthValidation(request.password!, miniLengh: 6, errorKey: localizedTextFor(key: GeneralValidations.PasswordValidaton.rawValue)) {
//            self.presenter?.presentWrongPassword(confirmPassword:true)
//            isValid = false
//            
//        }
        else if !validator.requiredValidation(request.confirmPassword!, errorKey: localizedTextFor(key: GeneralValidations.ConfirmPasswordKey.rawValue)) {
            
            self.presenter?.presentWrongPassword(confirmPassword:false)
            isValid = false
            
        } else if request.confirmPassword! != request.password! {
            
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: GeneralValidations.MismatchPasswordKey.rawValue)))
            self.presenter?.presentWrongPassword(confirmPassword:true)
            return false
        } else if request.oldpassword != nil && request.confirmPassword! == request.oldpassword! {
            CustomAlertController.sharedInstance.showErrorAlert(error: localizedTextFor(key: localizedTextFor(key: GeneralValidations.SamePasswordKey.rawValue)))
            self.presenter?.presentWrongPassword(confirmPassword:true)
            return false
        }
        
        return isValid
    }
}

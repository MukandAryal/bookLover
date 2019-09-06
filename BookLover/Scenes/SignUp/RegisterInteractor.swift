//
//  RegisterInteractor.swift
//  BookLover
//
//  Created by ios 7 on 09/05/18.
//  Copyright (c) 2018 iOS Team. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegisterBusinessLogic
{
    func signUpAPI(request: Register.Request)

}

protocol RegisterDataStore
{
  //var name: String { get set }
}

class RegisterInteractor: RegisterBusinessLogic, RegisterDataStore
{
  var presenter: RegisterPresentationLogic?
  var worker: RegisterWorker?
  //var name: String = ""
  
  // MARK: Do something
    func signUpAPI(request: Register.Request)  {
        
        if isValidRequest(request: request) {
            worker = RegisterWorker()
            let param = [
                "password":request.password,
                "email":request.email,
                "firstname": request.name,
                "lastname" : request.lastName,
                "device_token": userDefault.value(forKey: "DeviceToken"),
                "iOS":"device_type",
                "deviceId":""
                ]
            
            worker?.hitSignUpApi(parameters: param as! [String : String], apiResponse: { (response) in
                self.presenter?.presentSignUpResponse(response: response)
            })
        }
    }
    func isValidRequest(request: Register.Request) -> Bool {
        
        var isValid = true
        let validator = Validator()
        if !validator.requiredValidation(request.name!, errorKey: localizedTextFor(key: GeneralValidations.EnterFirstNameKey.rawValue)) {
            isValid = false
            
        } else if !validator.requiredValidation(request.lastName!, errorKey: localizedTextFor(key: GeneralValidations.EnterLastNameKey.rawValue)) {
                isValid = false
                
        } else if !validator.requiredValidation(request.email!, errorKey: localizedTextFor(key: GeneralValidations.EnterEmailKey.rawValue)) {
            isValid = false
            
        } else if !validator.emailValidation(request.email!, errorKey: localizedTextFor(key: GeneralValidations.InvalidEmailKey.rawValue)) {
            self.presenter?.presentWrongPassword(confirmPassword:true)
            self.presenter?.presentWrongEmail()
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
        }
        
        return isValid

    }
}
//
//  ForgotPasswordInteractor.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit

protocol ForgotPasswordBusinessLogic
{
    func forgotPasswordRequest(request: ForgotPassword.Request)
}

protocol ForgotPasswordDataStore
{
    //var name: String { get set }
}

class ForgotPasswordInteractor: ForgotPasswordBusinessLogic, ForgotPasswordDataStore
{
    var presenter: ForgotPasswordPresentationLogic?
    var worker: ForgotPasswordWorker?
    //var name: String = ""
    
    
    
    // MARK: Request Methods
    
    func forgotPasswordRequest(request: ForgotPassword.Request)
    {
        if isValidRequest(request: request)
        {
            worker = ForgotPasswordWorker()
            worker?.hitForgotPasswordApi(request: request, apiResponse: { (response) in
                self.presenter?.presentForgotPasswordResponse(response: response)
            })
        }
    }
    
    //MARK:- Validation
    
    func isValidRequest(request: ForgotPassword.Request) -> Bool {
        
        var isValid = true
        let validator = Validator()
        if !validator.requiredValidation(request.email!, errorKey: localizedTextFor(key: GeneralValidations.EnterEmailKey.rawValue)) {
            isValid = false
            
        } else if !validator.emailValidation(request.email!, errorKey: localizedTextFor(key: GeneralValidations.InvalidEmailKey.rawValue)) {
            isValid = false
            
        }
        return isValid
    }
   
}

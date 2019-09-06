//
//  ForgotPasswordPresenter.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit

protocol ForgotPasswordPresentationLogic
{
     func presentForgotPasswordResponse(response: ApiResponse)
}

class ForgotPasswordPresenter: ForgotPasswordPresentationLogic
{
    
    weak var viewController: ForgotPasswordDisplayLogic?
    
    
    // MARK: Display Forgot Password Response
    
   
    func presentForgotPasswordResponse(response: ApiResponse)
    {
        var model = ForgotPassword.ViewModel()
        if response.code == SuccessCode {
            let res = response.result as! NSDictionary
            model = ForgotPassword.ViewModel(message: res["result"] as? String ?? "", error: nil)
        } else {
            model = ForgotPassword.ViewModel(message: nil, error: response.error)
        }
        viewController?.displayForgotPasswordResponse(viewModel: model)
    }
}

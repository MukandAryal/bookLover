//
//  RegisterPresenter.swift
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

protocol RegisterPresentationLogic
{
    func presentSignUpResponse(response: ApiResponse)
    func presentWrongPassword(confirmPassword:Bool)
    func presentWrongEmail()

}

class RegisterPresenter: RegisterPresentationLogic
{
  weak var viewController: RegisterDisplayLogic?
  
  // MARK: Do something
    func presentSignUpResponse(response: ApiResponse)
    {
        if response.code == 409 {
            viewController?.displayWrongPassword(confirmPassword:true)
            viewController?.displayWrongEmail()
        }
        var viewModel = Register.ViewModel()
        if  response.code == SuccessCode {
            let result = response.result as! NSDictionary
            viewModel = Register.ViewModel(error: nil, message: result["result"] as? String)
        } else {
            viewModel = Register.ViewModel(error: response.error, message: nil)
        }
        viewController?.displaySignUpResponse(viewModel: viewModel)
    }
    
    func presentWrongPassword(confirmPassword:Bool) {
        viewController?.displayWrongPassword(confirmPassword:confirmPassword)
    }
    
    func presentWrongEmail() {
        viewController?.displayWrongEmail()
    }

}

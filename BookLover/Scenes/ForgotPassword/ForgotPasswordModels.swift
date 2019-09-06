//
//  ForgotPasswordModels.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit

struct ForgotPassword
{
    // MARK: Use cases
    
    struct Request
    {
        var email: String?
    }
    struct ViewModel
    {
        var message: String?
        var error : String?
        
    }
}

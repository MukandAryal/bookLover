//
//  ForgotPasswordRouter.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit

@objc protocol ForgotPasswordRoutingLogic
{
    func navigateBack()
}

protocol ForgotPasswordDataPassing
{
    var dataStore: ForgotPasswordDataStore? { get }
}

class ForgotPasswordRouter: NSObject, ForgotPasswordRoutingLogic, ForgotPasswordDataPassing
{
    weak var viewController: ForgotPasswordViewController?
    var dataStore: ForgotPasswordDataStore?
    
    
    
    // MARK: Navigation
    
    func navigateBack()
    {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
}

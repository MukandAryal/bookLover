//
//  RegisterModels.swift
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

enum Register
{
  // MARK: Use cases
  
    struct Request
    {
        var name: String?
        var email: String?
        var password: String?
        var confirmPassword: String?
        var lastName: String?
//        var lat:
    }
    
    struct ViewModel
    {
        var error: String?
        var message: String?
    }
}

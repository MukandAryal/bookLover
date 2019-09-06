//
//  CompleteProfileModels.swift
//  BookLover
//
//  Created by ios 7 on 10/05/18.
//  Copyright (c) 2018 iOS Team. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects
//  see http://clean-swift.com
//

import UIKit

enum CompleteProfile
{
  // MARK: Use cases
  
  
    struct Request
    {
        struct State {
            var countryId: String?
        }
        
        struct UserInfo {
            var user_Id: String?
        }
        
        struct UpdateProfile {
            var name: String?
            var lastName : String?
            var about: String?
            var gender: String?
            var state: String?
            var country: String?
            var user_image: UIImage?
            var age: String?
            var user_Id: String?
        }
    }
    struct Response
    {
    }
    
    struct ViewModel
    {
        struct CountryData {
            var id: Int16?
            var sortname: String?
            var name: String?
            var phonecode: Int16?
        }
        
        struct StateData {
            var id: Int16?
            var name: String?
            var country_id: Int16?
        }
        
        var countryList: [CountryData]?
        var stateList: [StateData]?
        var error: String?
    }
    
    struct UserInfo {
        var name: String?
        var lastName : String?
        var about: String?
        var gender: String?
        var state: String?
        var country: String?
        var user_image: String?
        var age: Int?
        var error: String?
    }
    
    struct UpdateProfile {
        var result: String?
        var error: String?
    }
    
}

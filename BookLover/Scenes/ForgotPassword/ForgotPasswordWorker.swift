//
//  ForgotPasswordWorker.swift
//  MagentoMobileShop
//
//  Created by A1_Coder... on 09/02/18.
//  Copyright (c) 2018 Coder. All rights reserved.
//


import UIKit
import Alamofire

typealias ForgotPasswordCompletionHandler = ((_ response: [String:Any]?, _ error: Error?) -> (Void))

class ForgotPasswordWorker
{
    
    //MARK:- ForgotPassword APIs
    func hitForgotPasswordApi(request: ForgotPassword.Request, apiResponse:@escaping(responseHandler)) {
        
        let endUrl = ApiEndPoints.forgotPassword
        
        let headersArray:HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["email":request.email!,]
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: endUrl, httpMethod: .post, headers: headersArray, parameters: param, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
  
}

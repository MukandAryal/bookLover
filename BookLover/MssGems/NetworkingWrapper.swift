/**
 This is a wrapper of Networking library .
 */

import UIKit
import Alamofire

class NetworkingWrapper: NSObject {
    
    static let sharedInstance = NetworkingWrapper()
    static let apiManager = Alamofire.SessionManager.default
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    private override init() {}
    
    /**
     Call this function to check if the internet is active or not.
     */
    
    func isConnectedToInternet() -> Bool {
        return reachabilityManager!.isReachable
    }
    
    /**
     Call this function to hit api with headers and parameters
     */
    
    func connect(urlEndPoint:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, parameters:[String:Any]?, encoding: ParameterEncoding?,  apiResponse:@escaping(responseHandler)) {
        
        let urlString = "\(Configurator.baseURL)\(urlEndPoint)"
        let validUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        printToConsole(item: parameters as Any)
        printToConsole(item: headers as Any)
        printToConsole(item: validUrlString!)
        
//        if reachabilityManager!.isReachable {
        showRetryAlert {
        
            ManageHudder.sharedInstance.startActivityIndicator()
            
            var paramEncoding: ParameterEncoding = JSONEncoding.default
            if encoding != nil {
                paramEncoding = encoding!
            }
           
            Alamofire.request(validUrlString!, method: httpMethod, parameters: parameters, encoding: paramEncoding, headers: headers).responseJSON { response in
                ManageHudder.sharedInstance.stopActivityIndicator()
                   printToConsole(item: response.error)
                if response.result.isSuccess {
                    
                    if let rawJson = response.result.value as? NSDictionary {
                        
                        printToConsole(item: rawJson)
                       
                        let parsedResponse = self.parseResponse(rawJson: rawJson)
                        if parsedResponse.code == 408 {
                            CommonFunctions.sharedInstance.removeUserData()
                            CommonFunctions.sharedInstance.navigateLoginVC()
                            return
                        }
                        apiResponse(parsedResponse)
                        
                    } else {
                        apiResponse(ApiResponse(code: FailureCode, error: localizedTextFor(key: ValidationsText.kJsonError.rawValue), result: nil))
                    }
                    
                } else {
                    apiResponse(ApiResponse(code: FailureCode, error: localizedTextFor(key: ValidationsText.kServerError.rawValue), result: nil))
                }
            }
        }
            
//        } else {
           // CustomAlertController.sharedInstance.showInternetAlert()
//        }
    }
    
    /**
     Call this function to hit api without headers and with parameters
     */
    
    func connect(urlEndPoint:String, httpMethod:HTTPMethod, parameters:[String:Any]?,  apiResponse:@escaping(responseHandler)) {
        connect(urlEndPoint: urlEndPoint, httpMethod: httpMethod, headers: nil, parameters: parameters, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    /**
     Call this function to hit api with headers and without parameters
     */
    
    func connect(urlEndPoint:String, httpMethod:HTTPMethod, headers:HTTPHeaders?,  apiResponse:@escaping(responseHandler)) {
        connect(urlEndPoint: urlEndPoint, httpMethod: httpMethod, headers: headers, parameters: nil, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    /**
     Call this function to hit api without headers and without parameters
     */
    
    func connect(urlEndPoint:String, httpMethod:HTTPMethod,  apiResponse:@escaping(responseHandler)) {
        connect(urlEndPoint: urlEndPoint, httpMethod: httpMethod, headers: nil, parameters: nil, encoding: nil) { (response) in
            apiResponse(response)
        }
    }
    
    /**
     Call this function to hit Multi part api
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, parameters:[String:Any]?, headers:HTTPHeaders?, images:[UIImage]?, imageName:String?,  apiResponse:@escaping(responseHandler)) {
        
        let urlString = "\(Configurator.baseURL)\(urlEndPoint)"
        let validUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        printToConsole(item:parameters as Any)
        printToConsole(item:headers as Any)
        printToConsole(item:validUrlString as Any)
        printToConsole(item:imageName as Any)
        
        
        if reachabilityManager!.isReachable {
            ManageHudder.sharedInstance.startActivityIndicator()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if let imagesArray = images {
                    for image in imagesArray {
                        multipartFormData.append(UIImageJPEGRepresentation(image, 1)!, withName: "\(imageName!)", fileName: "\(imageName!).jpeg", mimeType: "image/jpeg")
                        
                        printToConsole(item:"\(imageName!).jpeg" as Any)
                    }
                }
                
                if parameters != nil {
                    for (key, value) in parameters! {
                        multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, usingThreshold: UInt64.init(),
               to: validUrlString!,
               method: httpMethod,
               headers: headers)
            { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        printToConsole(item: progress)
                    })
                    
                    upload.responseJSON { response in
                        printToConsole(item: response.result)
                        ManageHudder.sharedInstance.stopActivityIndicator()
                        if let jsonDict = response.result.value as? NSDictionary {
                            printToConsole(item: jsonDict)
                            apiResponse(self.parseResponse(rawJson: jsonDict))
                        }
                        else {
                            apiResponse(ApiResponse(code: FailureCode, error: localizedTextFor(key: ValidationsText.kJsonError.rawValue), result: nil))
                        }
                    }
                    
                case .failure(let encodingError):
                   ManageHudder.sharedInstance.stopActivityIndicator()
                   printToConsole(item:encodingError.localizedDescription)
                    apiResponse(ApiResponse(code: FailureCode, error: localizedTextFor(key: ValidationsText.kServerError.rawValue), result: nil))
                }
            }
        }
        else {
            CustomAlertController.sharedInstance.showInternetAlert()
        }
    }
    
    /**
     Call this function to hit Multipart api without image
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, parameters:[String:Any],  apiResponse:@escaping(responseHandler)) {
        
        connectWithMultiPart(urlEndPoint: urlEndPoint, httpMethod: httpMethod, parameters: parameters, headers: headers, images: nil, imageName: nil) { (response) in
            apiResponse(response)
        }
    }
    
    
    /**
     Call this function to hit Multipart api without image and without headers
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, parameters:[String:Any]?,  apiResponse:@escaping(responseHandler)) {
        
        connectWithMultiPart(urlEndPoint: urlEndPoint, httpMethod: httpMethod, parameters: parameters, headers: nil, images: nil, imageName: nil) { (response) in
            apiResponse(response)
        }
    }
    
    
    /**
     Call this function to hit Multipart api with headers and without parameters
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, headers:HTTPHeaders?, images:[UIImage]?, imageName:String,  apiResponse:@escaping(responseHandler)) {
        
        connectWithMultiPart(urlEndPoint: urlEndPoint, httpMethod: httpMethod, parameters: nil, headers: headers, images: images, imageName: imageName) { (response) in
            apiResponse(response)
        }
    }
    
    
    /**
     Call this function to hit Multipart api without headers and with parameters
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, parameters:[String:Any]?, images:[UIImage]?, imageName:String,  apiResponse:@escaping(responseHandler)) {
        
        connectWithMultiPart(urlEndPoint: urlEndPoint, httpMethod: httpMethod, parameters: parameters, headers: nil, images: images, imageName: imageName) { (response) in
            apiResponse(response)
        }
    }
    
    
    /**
     Call this function to hit Multipart api without headers and without parameters
     */
    
    func connectWithMultiPart(urlEndPoint:String, httpMethod:HTTPMethod, images:[UIImage]?, imageName:String,  apiResponse:@escaping(responseHandler)) {
        
        connectWithMultiPart(urlEndPoint: urlEndPoint, httpMethod: httpMethod, parameters: nil, headers: nil, images: images, imageName: imageName) { (response) in
            apiResponse(response)
        }
    }
    
    func parseResponse(rawJson:NSDictionary) -> ApiResponse {
        
        let status = rawJson["success"] as! Bool
        
        if status == true {
            let resultObj = rawJson["data"]
            return ApiResponse(code: SuccessCode, error: nil, result: resultObj)
        } else {
            if let errorData = (rawJson["data"] as? NSDictionary) {
                let code = errorData["code"] as? NSNumber ?? 0
                let error = errorData["message"] as? String ?? ""
                return ApiResponse(code: code, error: error, result: nil)
            } else {
                return ApiResponse(code: FailureCode, error: localizedTextFor(key: localizedTextFor(key: ValidationsText.kServerError.rawValue)), result: nil)
            }
        }
    }
    
    func showRetryAlert(_ response:@escaping () -> Void) {
        
        if self.isConnectedToInternet() {
            response()
        }
        else {
            let alert = UIAlertController(title: localizedTextFor(key: GeneralText.appName.rawValue), message: localizedTextFor(key: ValidationsText.kNetworkError.rawValue), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                if !self.isConnectedToInternet() {
                    alert.dismiss(animated: true, completion: nil)
                    appDelegateObj.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else {
                    response()
                }
            }))
            appDelegateObj.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}



typealias responseHandler = (_ response: ApiResponse) ->()
typealias networkHandler = (_ noNetwork: String) ->()

//struct ApiResponse {
//    var status:NSNumber
//    var code:NSNumber?
//    var error:String?
//    var result:Any?
//}

struct ApiResponse {
    var code:NSNumber?
    var error:String?
    var result:Any?
}

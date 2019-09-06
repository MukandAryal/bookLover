//
//  API.swift
//


import UIKit
import Alamofire

enum HTTP: String {
    case POST = "Post"
    case PUT = "Put"
    case DELETE = "Delete"
    case GET = "Get"
}

typealias handlerr = ((_ response: Any?, _ error: Error?) -> (Void))

class API: NSObject {
    
    static let sharedInstance = API()
    
    func apiData(urlString: String, httpMethod: HTTP.RawValue, header:HTTPHeaders , info: Data?, completion: @escaping handlerr) {
        
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = header
        
        if ((httpMethod == HTTP.POST.rawValue) || (httpMethod == HTTP.PUT.rawValue)) {
            
            do {
                request.httpBody = info
            }
        }
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "Error")
            }
            
            do {
                let responseData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                DispatchQueue.main.async { completion(responseData, error)}
            } //catch {
            //                DispatchQueue.main.async { completion(responseData, error)}
            //            }
        })
        
        dataTask.resume()
    }
}

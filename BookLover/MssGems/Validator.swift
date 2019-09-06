/**
 This is a text validator class which contains validation functions for most used cases like email validation, required validation etc.
 */

import UIKit

class Validator: NSObject {
    
    func passwordValidation(_ password: String, errorKey: String) -> Bool {
        
//        let strP = password.replacingOccurrences(of: " ", with: "")
//        if strP.count > 0 {
            let pass = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{6,}$"
            let passPredicate = NSPredicate(format:"SELF MATCHES %@", pass)
            if !(passPredicate.evaluate(with: password)) {
                CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
                return false
            } else {
                return true
            }
//        } else {
//            CustomAlertController.sharedInstance.showErrorAlert(error: "Space is not allowed")
//            return false
//        }
    }
    
     func emailValidation(_ email:String, errorKey:String) -> Bool  {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !(emailPredicate.evaluate(with: email)) {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
            return false
        }else {
            return true
        }
    }
    
    func requiredValidation(_ text:String, errorKey:String) -> Bool {
        if text == "" {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
            return false
        }
        return true
    }
    
    func stringLengthValidation(_ text:String, miniLengh:Int, errorKey:String) -> Bool {
        
        if !(text.count >= miniLengh) {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
            return false
        }else {
            return true
        }
    }
    
    func phoneNoLengthValidation(_ text:String, errorKey:String) -> Bool {
        if !(text.count >= 10 && text.count <= 12) {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
            return false
        }else {
            return true
        }
    }
    
    func passwordLengthValidation(_ text:String, errorKey:String) -> Bool {
        if !(text.count >= 6 && text.count <= 25) {
            CustomAlertController.sharedInstance.showErrorAlert(error: errorKey)
            return false
        }else {
            return true
        }
    }
}

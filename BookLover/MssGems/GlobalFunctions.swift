
import Foundation

/**
 Call this function to print anything on console.
 */

func printToConsole(item: Any) {
    if Configurator.consolePrintingEnabled.boolValue() {
        print(item)
    }
}


/**
 Call this function for showing localized text instead of default nslocalized constructor in every class.
 */

func localizedTextFor(key:String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: "", comment: "")
}

/**
 Call this function to get any attribute related to logged in user.
 */


//func getUserData(_ attribute:userAttributes) -> String {
//    if attribute == .birthday {
//        let birthdateMilliseconds =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? Int ?? 0
//        return birthdateMilliseconds.description
//    }
//    else if attribute == .notification {
//        let notification =  appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? Int ?? 0
//        return notification.description
//    }
//    else {
//        return appDelegateObj.userDataDictionary.value(forKey: attribute.rawValue) as? String ?? ""
//    }
//}


//func isUserLoggedIn() -> Bool {
//    return userDefault.bool(forKey: userDefualtKeys.userLoggedIn.rawValue)
//}


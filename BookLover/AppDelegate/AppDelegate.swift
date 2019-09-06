//
//  AppDelegate.swift
//  BookLover
//
//  Created by ios 7 on 07/05/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKLoginKit
import Firebase
import UserNotifications
import CoreData
import Starscream

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userData = NSMutableDictionary()
    let gcmMessageIDKey = "gcm.message_id"
    let gcmMessageData = "gcm.notification.userInfo"
    let gecmNotificationData = "gcm.notification.image"
    var devicetoken : String?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        Fabric.with([Crashlytics.self])
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        //   [END register_for_notifications]
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    //MARK: - [START receive_message] --
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            print(userInfo)
        }
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            // Print full message.
            print(userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
            
        }
        
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    //MARK: - Open Url --
    
    @available(iOS 9.0, *)
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        // Add any custom logic here.
        return handled
    }
    
    
    //MARK: -- Helper
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("error in decoding -- \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    
    func unarchiveUserData() {
        // UnArchiving user attributes object
        if let userData:Data = userDefault.value(forKey: userDefualtKeys.userObject.rawValue) as? Data {
            if let userDict = NSKeyedUnarchiver.unarchiveObject(with: userData) {
                self.userData = (userDict as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BookLover")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func passDataToChatView(FromUserId: Int,userName:String,userImage:String, destinationDS: inout ChatDataStore)
    {
        destinationDS.from_user_id = FromUserId
        destinationDS.userName = userName
        destinationDS.userImage = userImage
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            let userInfo = notification.request.content.userInfo
            print("userInfo: \(userInfo)")
            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            // Print full message.
            let topVC = CommonFunctions.sharedInstance.topViewController()
            if (topVC?.isKind(of: ChatViewController.self))! {
                return
            }
            // Change this to your preferred presentation option
            completionHandler([.alert])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if CommonFunctions.sharedInstance.isUserLoggedIn() {
            
            
        
        let userInfo = response.notification.request.content.userInfo
        printToConsole(item: userInfo)
        
        var fromUserId : Int?
        var userImage : String?
//        let strName : NSMutableString = ""
        var fullname:String?
        
        if userInfo.keys.contains(gcmMessageData) {
            
            if let convertDict = convertToDictionary(text: userInfo[gcmMessageData] as! String)  {

                fromUserId = convertDict["user_id"] as? Int
                userImage = convertDict["user_image"] as? String
                fullname = convertDict["user_name"] as? String
                
//                let data : NSDictionary?
//                if convertDict["data"] != nil {
//                    let dataUserInfo = convertDict["data"] as? NSDictionary
//                    data = dataUserInfo!["userInfo"] as? NSDictionary
//                }else {
//                    data = convertDict as NSDictionary
//                }
                
               // ["user_id":data["id"]!,"user_name":fullname!, "user_image": data["user_image"]!]
               

//                fromUserId = data!["id"] as? Int
//                userImage = data!["user_image"] as? String
//                if data!["firstname"] as? String != nil, let _ = data!["firstname"] as? String {
//                    strName.append((data!["firstname"])! as! String)
//                    strName.append(" ")
//                }
//                if data!["lastname"] != nil, let _ = data!["lastname"] {
//                    strName.append((data!["lastname"])! as! String)
//                }
//                fullname = strName as String
            }
        }
        let storyboard = AppStoryboard.Main.instance
        let type = userInfo["gcm.notification.type"] as? String
        if type == "message"{
            
            if fromUserId != nil {
                let navigationController = window?.rootViewController as? UINavigationController
                let vcObj = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.ChatController) as? ChatViewController
                var ds = vcObj!.router?.dataStore
                passDataToChatView(FromUserId: fromUserId! ,userName:fullname! ,userImage:userImage!, destinationDS: &ds!)
                navigationController?.pushViewController(vcObj!, animated: true)
                
            } else {
                
                let topVC = CommonFunctions.sharedInstance.topViewController()
                if (topVC?.isKind(of: HomeViewController.self))! {
                    return
                }
                let navigationController = window?.rootViewController as? UINavigationController
                let vcObj = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.Home) as? HomeViewController
                navigationController?.pushViewController(vcObj!, animated: true)
            }
        }else{
            
            let navigationController = window?.rootViewController as? UINavigationController
            let vcObj = storyboard.instantiateViewController(withIdentifier: ViewControllerIds.Notification) as? AllNotificationViewController
            navigationController?.pushViewController(vcObj!, animated: true)
        }
        completionHandler()
    }
    }
}

// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        userDefault.set(fcmToken as? String, forKey:"DeviceToken")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

//extension AppDelegate : CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        printToConsole(item: "Error in getting location \(error.localizedDescription)")
//    }
//}

// MARK: - Core Data stack


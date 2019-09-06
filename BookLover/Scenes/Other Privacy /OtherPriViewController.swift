//
//  OtherPriViewController.swift
//  BookLover
//
//  Created by Mss Mukunda on 05/06/18.
//  Copyright © 2018 iOS Team. All rights reserved.
//

import UIKit
import Alamofire


class OtherPriViewController: UIViewController {
    
    var isPrivate: Bool = false
    var isLastSeen: Bool = false
    
    @IBOutlet weak var acceptPrivateMessageLbl: UILabelFontSize!
    @IBOutlet weak var swtichBtn: UISwitch!
    @IBOutlet weak var lblLastSeen: UILabelFontSize!
    
    @IBOutlet weak var swtBtnLastSeen: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func changeValue(){
        if swtichBtn.isOn {
            isPrivate = true
        } else {
            isPrivate = false
        }
        hitsetPrivicyApi()
    }
    
    func lastSeenChangeValue(){
        if swtBtnLastSeen.isOn {
            isLastSeen = true
        } else {
            isLastSeen = false
        }
        hitsetLastSeenApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    func setUpInterface() {
        
        let privacyData = CommonFunctions.sharedInstance.getUserInfoPrivacyData()
        printToConsole(item: privacyData)
        
        let message = privacyData["message"] as? Int
        if message == 0 {
            swtichBtn.isOn = false
        }else{
            swtichBtn.isOn = true
        }
        
        let lastSeen = privacyData["last_seen"] as? Int
        if lastSeen == 0 {
            swtBtnLastSeen.isOn = false
        }else{
            swtBtnLastSeen.isOn = true
        }
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.OtherPrivacyTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        acceptPrivateMessageLbl.text = localizedTextFor(key: OtherPrivacyText.acceptPrivateMessage.rawValue)
        lblLastSeen.text = localizedTextFor(key: OtherPrivacyText.lastSeen.rawValue)
        
    }
    
    //MARK:- hitsetPrivicyApi --
    func hitsetPrivicyApi(){
        
        var param = CommonFunctions.sharedInstance.getUserInfoPrivacyData()
        param["message"] = isPrivate
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let hed:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.PrivicySet, httpMethod: .post, headers: hed, parameters: param as Any as? [String : Any], encoding: URLEncoding.default) { (response) in
            if response.code == SuccessCode {

                CustomAlertController.sharedInstance.showSuccessAlert(success: localizedTextFor(key: SucessfullyMessage.PrivacyPolicyMessage.rawValue))
                CommonFunctions.sharedInstance.updateUserInfoPrivacy("message", withValue: self.isPrivate ? 1: 0)
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    func hitsetLastSeenApi(){
        
        var param = CommonFunctions.sharedInstance.getUserInfoPrivacyData()
        param["last_seen"] = isLastSeen
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let hed:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]
        
        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.PrivicySet, httpMethod: .post, headers: hed, parameters: param as Any as? [String : Any], encoding: URLEncoding.default) { (response) in
            if response.code == SuccessCode {
                CustomAlertController.sharedInstance.showSuccessAlert(success: localizedTextFor(key: SucessfullyMessage.PrivacyPolicyMessage.rawValue))
                CommonFunctions.sharedInstance.updateUserInfoPrivacy("last_seen", withValue: self.isLastSeen ? 1: 0)
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    
    @IBAction func switchBtn(_ sender: Any) {
        changeValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionLastSeenSwtichBtn(_ sender: Any) {
        lastSeenChangeValue()
    }
}

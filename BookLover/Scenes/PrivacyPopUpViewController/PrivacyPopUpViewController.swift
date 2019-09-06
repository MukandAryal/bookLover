

import UIKit
import Alamofire

//MARK:- Outlet --
class PrivacyPopUpViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabelFontSize!
    @IBOutlet weak var btnPublic: UIButtonFontSize!
    @IBOutlet weak var btnFriends: UIButtonFontSize!
    @IBOutlet weak var btnNoOne: UIButtonFontSize!
    @IBOutlet weak var btnSubmit: UIButtonFontSize!
    @IBOutlet weak var imgPublic: UIImageView!
    @IBOutlet weak var imgFriends: UIImageView!
    @IBOutlet weak var imgNoOne: UIImageView!
    var titleStr:String = ""
    var privacyStatus : Int?
    
    //MARK:- viewWillAppear --
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    //MARK:- Class Helper --
    func setUpInterface() {
        
        lblTitle.text = titleStr
        self.navigationController?.isNavigationBarHidden = true
        btnSubmit.layer.cornerRadius = btnSubmit.frame.size.height/2.0
        btnSubmit.clipsToBounds = true
        
        btnPublic.setTitle(localizedTextFor(key: ProfilePrivacyText.publicTitle.rawValue), for: .normal)
        btnFriends.setTitle(localizedTextFor(key: ProfilePrivacyText.friendTitle.rawValue), for: .normal)
        btnNoOne.setTitle(localizedTextFor(key: ProfilePrivacyText.noOneTitle.rawValue), for: .normal)
        btnSubmit.setTitle(localizedTextFor(key: ProfilePrivacyText.addressEmail.rawValue), for: .normal)

        let userData = appDelegateObj.userData
        var privacyArr = userData["Privacies"] as! [[String:Any]]
        var privacyData = privacyArr[0]
        let profilePic = privacyData["profile_pic"] as? Int
        let emailAddress = privacyData["email"] as? Int
        let gender = privacyData["gender"] as? Int
        let age = privacyData["age"] as? Int
        let follow = privacyData["follow"] as? Int
        let comment = privacyData["comment"] as? Int
        
        if titleStr == localizedTextFor(key: ProfilePrivacyText.profilePicture.rawValue) {
            if profilePic == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if profilePic == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = profilePic
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.addressEmail.rawValue) {
            if emailAddress == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if emailAddress == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = emailAddress
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.age.rawValue) {
            if age == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if age == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = age
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.gender.rawValue) {
            if gender == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if gender == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = gender
        }else if titleStr == localizedTextFor(key: ReviewsPrivacyText.whoCanfollowMe.rawValue) {
            if follow == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if follow == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = follow
        }else{
            if comment == 0 {
                imgPublic.image = UIImage(named: "radio_active")
            }else if comment == 1 {
                imgFriends.image = UIImage(named: "radio_active")
            }else{
                imgNoOne.image = UIImage(named: "radio_active")
            }
            privacyStatus = comment
        }
    }
    
    //MARK:- setImageForStatus --
    func setImageForStatus(status:Int) {
        privacyStatus = status
        switch status {
        case 0:
            imgPublic.image = UIImage(named: "radio_active")
            imgFriends.image = UIImage(named: "radio_inactive")
            imgNoOne.image = UIImage(named: "radio_inactive")
            break
        case 1:
            imgPublic.image = UIImage(named: "radio_inactive")
            imgFriends.image = UIImage(named: "radio_active")
            imgNoOne.image = UIImage(named: "radio_inactive")
            break
        case 2:
            imgPublic.image = UIImage(named: "radio_inactive")
            imgFriends.image = UIImage(named: "radio_inactive")
            imgNoOne.image = UIImage(named: "radio_active")
            break
        default:
            imgPublic.image = UIImage(named: "radio_inactive")
            imgFriends.image = UIImage(named: "radio_inactive")
            imgNoOne.image = UIImage(named: "radio_inactive")
            break
        }
    }
    
    //MARK:- hitsetPrivicyApi --
    
    func hitsetPrivicyApi(){
        
        var parameters = CommonFunctions.sharedInstance.getUserInfoPrivacyData()
        
        var strToUpdate : String?
        if titleStr == localizedTextFor(key: ProfilePrivacyText.profilePicture.rawValue) {
            strToUpdate = "profile_pic"
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.addressEmail.rawValue) {
            strToUpdate = "email"
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.age.rawValue) {
            strToUpdate = "age"
        }else if titleStr == localizedTextFor(key: ProfilePrivacyText.gender.rawValue){
            strToUpdate = "gender"
        }
        else if titleStr == localizedTextFor(key: ReviewsPrivacyText.whoCanfollowMe.rawValue){
            strToUpdate = "follow"
        }
        else if titleStr == localizedTextFor(key: ReviewsPrivacyText.whoCanComment.rawValue){
            strToUpdate = "comment"
        }
        
        parameters.updateValue(privacyStatus!, forKey: strToUpdate!)
        
        let token = Configurator.tokenBearer + (userDefault.value(forKeyPath: userDefualtKeys.user_Token.rawValue) as! String)
        let hed:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","Authorization": token]

        NetworkingWrapper.sharedInstance.connect(urlEndPoint: ApiEndPoints.PrivicySet, httpMethod: .post, headers: hed, parameters: parameters, encoding: URLEncoding.default) { (response) in
            
            if response.code == SuccessCode {
                CommonFunctions.sharedInstance.updateUserInfoPrivacy(strToUpdate!, withValue: self.privacyStatus!)
                self.dismiss(animated: true, completion: {
                })
            } else {
                CustomAlertController.sharedInstance.showErrorAlert(error: response.error!)
            }
        }
    }
    
    //MARK:- Button Action --
    @IBAction func actionPublic(_ sender: Any) {
        setImageForStatus(status: 0)
    }
    @IBAction func actionFriends(_ sender: Any) {
        setImageForStatus(status: 1)
    }
    @IBAction func actionNoOne(_ sender: Any) {
        setImageForStatus(status: 2)
    }
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        hitsetPrivicyApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

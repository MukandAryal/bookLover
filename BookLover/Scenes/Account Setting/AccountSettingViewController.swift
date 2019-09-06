
import UIKit

typealias DeleteCompletion = (_ delete: Bool?) -> ()

protocol AccountSettingDisplayLogic: class
{
    func displaySendOtpResponse(viewModel: AccountSetting.ViewModel)
    func displayIsVerifyBook(isVerify:Bool)
    func displayChnageEmailResponse(viewModel: AccountSetting.ViewModel)
    func displayDeleteAccountResponse(viewModel: AccountSetting.ViewModel)
}

class AccountSettingViewController: UIViewController, AccountSettingDisplayLogic
{
    var interactor: AccountSettingBusinessLogic?
    var router: (NSObjectProtocol & AccountSettingRoutingLogic & AccountSettingDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = AccountSettingInteractor()
        let presenter = AccountSettingPresenter()
        let router = AccountSettingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    //MARK:- Outlet --
    
    @IBOutlet weak var emailAddressTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxtFld: SkyFloatingLabelTextField!
    
    @IBOutlet weak var deleteAccountBtn: UIButtonFontSize!
    @IBOutlet weak var resetPasswordBtn: UIButtonFontSize!
    @IBOutlet weak var btnChangeEmail: UIButtonFontSize!
    var btnSaveEmail : UIButtonFontSize?
    
    @IBOutlet weak var changeEmailArrow: UIImageView!

    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var isVerify: Bool?
    
    //MARK:- viewDidLoad --
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //MARK:- viewWillAppear --
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRightBarButton()
        setUpInterface()
    }
    
    //MARK:- Class Helper --
    
    func setUpInterface(){
        
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.AccountSettingsTitle.rawValue))
        CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        

        emailAddressTxtFld.placeholder = localizedTextFor(key: AccountSettingText.emailAddress.rawValue)
         passwordTxtFld.placeholder = localizedTextFor(key: AccountSettingText.password.rawValue)
        emailAddressTxtFld.text = appDelegateObj.userData["email"] as? String
        passwordTxtFld.text = localizedTextFor(key: AccountSettingText.password.rawValue)
        passwordTxtFld.isUserInteractionEnabled = false
        passwordTxtFld.isSecureTextEntry = true
        deleteAccountBtn.setTitle(localizedTextFor(key: AccountSettingText.deleteAccount.rawValue), for:.normal)
        deleteAccountBtn.layer.cornerRadius = deleteAccountBtn.frame.size.height/2
        deleteAccountBtn.layer.borderWidth = 1
        deleteAccountBtn.layer.borderColor = UIColor.yellow.cgColor
        btnChangeEmail.setTitle(localizedTextFor(key:AccountSettingText.changeEmail.rawValue), for: .normal)
        resetPasswordBtn.setTitle(localizedTextFor(key:AccountSettingText.changePassword.rawValue), for: .normal)
        
        onloadSettings()
        interactor?.presentVerifyBool()
        if let _ = appDelegateObj.userData["email"] as? String {
           return
        } else {
           editEmailFieldSetting()
        }
    }
    
    func setRightBarButton() {
        
        btnSaveEmail = UIButtonFontSize(type: .custom)
        btnSaveEmail?.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btnSaveEmail?.setAttributedTitle(NSAttributedString(string: localizedTextFor(key: GeneralText.SaveTitle.rawValue), attributes: [NSAttributedStringKey.font: UIFont(name: "Futura", size: 17)!, NSAttributedStringKey.foregroundColor : appThemeColor]), for: .normal)
        btnSaveEmail?.addTarget(self, action: #selector(actionSave(_:)), for: UIControlEvents.touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: btnSaveEmail!)
        
        self.navigationItem.setRightBarButtonItems([saveBarButton], animated: false)
    }
    
    
    func onloadSettings() {
        
        emailAddressTxtFld.isUserInteractionEnabled = false
        deleteAccountBtn.isHidden = false
        btnChangeEmail.isHidden = false
        changeEmailArrow.isHidden = false
        
        btnSaveEmail?.isHidden = true
        deleteAccountBtn.isUserInteractionEnabled = true
        resetPasswordBtn.isUserInteractionEnabled = true
        resetPasswordBtn.isUserInteractionEnabled = true
        btnChangeEmail.isUserInteractionEnabled = true
    }
    
   
    func editEmailFieldSetting() {
        emailAddressTxtFld.isUserInteractionEnabled = true
        emailAddressTxtFld.becomeFirstResponder()
        deleteAccountBtn.isHidden = true
        resetPasswordBtn.isUserInteractionEnabled = false
        btnSaveEmail?.isHidden = false
        btnChangeEmail.isHidden = true
        changeEmailArrow.isHidden = true
    }
    
    func presentDeleteAccountAction() -> DeleteCompletion {
        
        return { [unowned self] delete in
            if delete == true {
                self.interactor?.deleteAccountApi()
            }else{
                return
            }
        }
    }
    
    //MARK:- Display SendOtp Response --
    
    func displayDeleteAccountResponse(viewModel: AccountSetting.ViewModel) {
        if let error = viewModel.error{
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }else{
            userDefault.set(false, forKey: userDefualtKeys.userLoggedIn.rawValue)
            userDefault.set(false, forKey: userDefualtKeys.userProfileCompleted.rawValue)
            // updating user data in user default
            userDefault.removeObject(forKey: userDefualtKeys.userObject.rawValue)
            // Clears app delegate user object dictioary
            appDelegateObj.userData.removeAllObjects()
            CommonFunctions.sharedInstance.navigateToHome(nav: self.navigationController!)
        }
    }
    
    func displaySendOtpResponse(viewModel: AccountSetting.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
            router?.navigateToEmailVerificationScene()
        }
    }
   
    //MARK:- Display VerifyOtp Response --
    func displayIsVerifyBook(isVerify: Bool) {
        if isVerify == true {
            editEmailFieldSetting()
        }
    }
    
    //MARK:- Display Change Email Response --
    
    func displayChnageEmailResponse(viewModel: AccountSetting.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
            //emailAddressTxtFld.text = appDelegateObj.userData["email"] as? String
        }else{
           CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
            appDelegateObj.userData["email"] = emailAddressTxtFld.text
            onloadSettings()
        }
    }
    
    //MARK:- Button Action Helper --

    @IBAction func actionDeleteAccount(_ sender: Any) {
        router?.navigateToDeleteAccountScene()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        let requesEmail = AccountSetting.Request(email: emailAddressTxtFld.text_Trimmed())
        interactor?.changeEmailApi(request: requesEmail)
        //onloadSettings()
    }
    
    @IBAction func actionChangeEmail(_ sender: Any) {
        
        interactor?.sendOtpApi()
    }
    @IBAction func actionResetPassword(_ sender: Any) {
        router?.navigateToResetPasswordScene()
    }
}

extension AccountSettingViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
            return false
        }
        return true
    }
}

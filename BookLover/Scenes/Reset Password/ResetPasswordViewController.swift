

import UIKit

protocol ResetPasswordDisplayLogic: class
{
    func displayResetPasswordResponse(viewModel: ResetPassword.ViewModel)
    func displayWrongPassword(confirmPassword:Bool)
}

class ResetPasswordViewController: UIViewController, ResetPasswordDisplayLogic
{
    var interactor: ResetPasswordBusinessLogic?
    var router: (NSObjectProtocol & ResetPasswordRoutingLogic & ResetPasswordDataPassing)?
    
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
        let interactor = ResetPasswordInteractor()
        let presenter = ResetPasswordPresenter()
        let router = ResetPasswordRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    //////////////////////////////////////////////////////////
     // MARK: Outlet --
    @IBOutlet weak var oldPasswordTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var confromNewPasswordTxtFld: SkyFloatingLabelTextField!
    @IBOutlet weak var confromBtn: UIButtonFontSize!
    @IBOutlet weak var oldPasswordHeight: NSLayoutConstraint!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInterface()
    }
    
    // MARK: Class Helper --
    func setUpInterface() {
        CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.ResetPasswordTitle.rawValue))
      //  CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        
        oldPasswordTxtFld.placeholder = localizedTextFor(key:ResetPasswordText.oldPassword.rawValue)
        newPasswordTxtFld.placeholder = localizedTextFor(key:ResetPasswordText.newPassword.rawValue)
        confromNewPasswordTxtFld.placeholder = localizedTextFor(key: ResetPasswordText.confirmNewPassword.rawValue)
        confromBtn.setTitle(localizedTextFor(key:ResetPasswordText.confirmPassword.rawValue), for:.normal)
        oldPasswordTxtFld.isSecureTextEntry = true
        newPasswordTxtFld.isSecureTextEntry = true
        confromNewPasswordTxtFld.isSecureTextEntry = true
        confromBtn.layer.cornerRadius  = confromBtn.frame.size.height/2.0
       
        
        if (appDelegateObj.userData["resetPassword"] as? Bool) == false {
            oldPasswordHeight.constant = 0
            oldPasswordTxtFld.isHidden = true
        }else {
            oldPasswordHeight.constant = 50
            oldPasswordTxtFld.isHidden = false
        }
    }
    
    // MARK: Display Response--
    
    func displayWrongPassword(confirmPassword:Bool) {
        if  confirmPassword == true {
            newPasswordTxtFld.text = ""
        }
        confromNewPasswordTxtFld.text = ""
    }
    
    func displayResetPasswordResponse(viewModel: ResetPassword.ViewModel) {
        if let error = viewModel.error {
            oldPasswordTxtFld.text = ""
            newPasswordTxtFld.text = ""
            confromNewPasswordTxtFld.text = ""
             CustomAlertController.sharedInstance.showErrorAlert(error: error)
        }else{
            if (appDelegateObj.userData["resetPassword"] as? Bool) == false {
                let user = appDelegateObj.userData
                user["resetPassword"] = true
                appDelegateObj.userData = user
            }
           CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
           router?.navigateToAccountSetting(isverify: false)
        }
    }
    // MARK: Button Action--
    
    @IBAction func actionBackButton(_ sender: Any) {
        router?.navigateToAccountSetting(isverify: false)
    }
    
    @IBAction func actionResetPassword(_ sender: Any) {
        
        var requestResetPasword = ResetPassword.Request()
        if (appDelegateObj.userData["resetPassword"] as? Bool) == false {
            requestResetPasword = ResetPassword.Request(oldpassword: nil, password: newPasswordTxtFld.text_Trimmed(), confirmPassword: confromNewPasswordTxtFld.text_Trimmed())
        } else {
            requestResetPasword = ResetPassword.Request(oldpassword: oldPasswordTxtFld.text_Trimmed(), password: newPasswordTxtFld.text_Trimmed(), confirmPassword: confromNewPasswordTxtFld.text_Trimmed())
        }
        interactor?.resetPasswordApi(request: requestResetPasword)
     //   router?.navigateToAccountSetting(isverify: false)
    }
}

extension ResetPasswordViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if (string == " ") {
                return false
            }
            return true
    }
}

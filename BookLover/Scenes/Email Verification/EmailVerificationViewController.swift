
import UIKit
import KWVerificationCodeView

protocol EmailVerificationDisplayLogic: class
{
    func displayVerifyApiResponse(viewModel: EmailVerification.ViewModel)
    func displaySendOtpResponse(viewModel: EmailVerification.ViewModel)
}

class EmailVerificationViewController: UIViewController, EmailVerificationDisplayLogic
{
    var interactor: EmailVerificationBusinessLogic?
    var router: (NSObjectProtocol & EmailVerificationRoutingLogic & EmailVerificationDataPassing)?
    
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
        let interactor = EmailVerificationInteractor()
        let presenter = EmailVerificationPresenter()
        let router = EmailVerificationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: Outlet --
    @IBOutlet weak var emailFourDigitCodeLbl: UILabelFontSize!
    @IBOutlet weak var verificationCodeView: KWVerificationCodeView!
   
    @IBOutlet weak var submitBtn: UIButtonFontSize!
    @IBOutlet weak var dintGetTheCodeLbl: UILabelFontSize!
    @IBOutlet weak var resendCodeBtn: UIButtonFontSize!
    
     // MARK: viewDidLoad --
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpInterface()
    }
    
    // MARK: Class Helper --
    func setUpInterface(){
        
        verificationCodeView.delegate = self as? KWVerificationCodeViewDelegate; CustomNavigationItems.sharedInstance.setNavigationBarApperrance(onVC: self, withTitle: localizedTextFor(key: SettingsModuleText.EmailVarificationTitle.rawValue))
     //   CustomNavigationItems.sharedInstance.leftBarButton(onVC: self)
        emailFourDigitCodeLbl.text = localizedTextFor(key: EmailVerficationText.enter4digitcode.rawValue)
        submitBtn.setTitle(localizedTextFor(key:EmailVerficationText.submit.rawValue), for:.normal)
        dintGetTheCodeLbl.text = localizedTextFor(key:EmailVerficationText.dontGetTheCode.rawValue)
        submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2.0
        submitBtn.clipsToBounds = true
          resendCodeBtn.setAttributedTitle((localizedTextFor(key: EmailVerficationText.resendCode.rawValue)).underLine(color:appThemeColor, font: resendCodeBtn.titleLabel?.font), for: .normal)
    }
    
    // MARK: Display Response Helper --
    func displayVerifyApiResponse(viewModel: EmailVerification.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
            router?.navigateToAccountSetting(isverify : true)
        }
    }
    
    //MARK:- Display SendOtp Response --
    func displaySendOtpResponse(viewModel: EmailVerification.ViewModel) {
        if let error = viewModel.error {
            CustomAlertController.sharedInstance.showErrorAlert(error: error)
        } else {
            CustomAlertController.sharedInstance.showSuccessAlert(success: viewModel.message!)
        }
    }
    
    // MARK: Button Action --
    @IBAction func actionBackButton(_ sender: Any) {
        router?.navigateToAccountSetting(isverify : false)
    }
    
    @IBAction func actionResendCode(_ sender: Any) {
        interactor?.resendOtpApi()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        let code = verificationCodeView.getVerificationCode()
        let requestVerify  = EmailVerification.Request(otp: code.intValue())
        interactor?.emailVerficationApi(request:requestVerify)
       // router?.navigateToAccountSetting(isverify : true)
    }
}

